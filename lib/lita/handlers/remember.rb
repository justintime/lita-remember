module Lita
  module Handlers
    class Remember < Handler
      route(
        /^[Ww]hat(?:\s+(is|are))?\s(?<term>.*)(\s+)?/,
        :lookup,
        command: true,
        help: {
          t('help.what.syntax') => t('help.what.desc')
        }
      )

      route(
        /^[Rr]emember\s(?<term>.+)\s(is|are)\s(?<definition>.+)$/,
        :remember,
        command: true,
        help: {
          t('help.remember.syntax') => t('help.remember.desc')
        }
      )

      route(
        /^[Ff]orget\s(about\s)?(?<term>.+)/,
        :forget,
        command: true,
        help: {
          t('help.forget.syntax') => t('help.forget.desc')
        }
      )

      route(
        /^[Ww]hat do you remember\??$/,
        :all_the_terms,
        command: true,
        help: {
          t('help.all.syntax') => t('help.all.desc')
        }
      )

      route(
        /^[Ss]earch (?<type>(terms|definitions)) for (?<query>.*)$/,
        :search,
        command: true,
        help: {
          t('help.search.syntax') => t('help.search.desc')
        }
      )

      def lookup(response)
        term = response.match_data['term'].chomp('?')
        return response.reply(t('response.unknown', term: term)) unless known?(term)
        response.reply(format_definition(term, definition(term)))
      end

      def forget(response)
        term = response.match_data['term']
        delete(term)
        response.reply(format_deletion(term))
      end

      def remember(response)
        term = response.match_data['term']
        info = response.match_data['definition']
        write(term, info, response.user.id)
        response.reply(format_confirmation(term, definition(term)))
      end

      def search(response)
        type  = response.match_data['type']
        query = response.match_data['query']
        matching_terms = []
        if type == 'terms'
          terms = fetch_all_terms
          matching_terms = terms.select { |term| term.include?(query) }
        else
          fetch_all.each { |term,definition|
            matching_terms.push(term) if definition.include?(query)
          }
        end
        if matching_terms.empty?
          response.reply(t('response.empty_search_result', type: type))
        else
          response.reply(format_search(matching_terms.sort.join("\n - ")))
        end
      end

      def all_the_terms(response)
        response.reply(format_all_the_terms(fetch_all_terms.sort.join("\n - ")))
      end

      def fetch_all()
        results = {}
        redis.scan_each(:count => 1000) { |term|
          definition = redis.hmget(term,'definition')[0]
          results[term] = definition
        }
        return results
      end

      def fetch_all_terms()
        terms = []
        redis.scan_each(:count => 1000) { |term| terms << term }
        return terms
      end

      private

      def format_all_the_terms(terms)
        t('response.all', terms: terms)
      end

      def format_search(terms)
        t('response.search', terms: terms)
      end

      def format_deletion(term)
        t('response.forget', term: term)
      end

      def format_confirmation(term, definition)
        t('response.confirm', term: term, definition: definition[:term])
      end

      def format_definition(term, definition)
        username = Lita::User.find_by_id(definition[:userid]).name
        t('response.is', term: term, definition: definition[:term], count: definition[:hits], user: username)
      end

      def known?(term)
        redis.exists(term.downcase)
      end

      def definition(term)
        result = redis.hmget(term.downcase,'definition','hits', 'userid')
        redis.hincrby(term.downcase, 'hits', 1)
        record = {
          :term       => result[0],
          :hits       => result[1],
          :userid     => result[2],
        }
        return record
      end

      def delete(term)
        redis.del(term.downcase)
      end

      def write(term, definition, userid)
        redis.hset(term.downcase, 'definition', definition)
        redis.hset(term.downcase, 'userid', userid)
        redis.hset(term.downcase, 'hits', 0)
      end
    end
    Lita.register_handler(Remember)
  end
end
