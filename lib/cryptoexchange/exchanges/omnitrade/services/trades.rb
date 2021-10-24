module Cryptoexchange::Exchanges
  module Omnitrade
    module Services
      class Trades < Cryptoexchange::Services::Market
        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output, market_pair)
        end

        def ticker_url(market_pair)
          base = market_pair.base.downcase
          target = market_pair.target.downcase
          "#{Cryptoexchange::Exchanges::Omnitrade::Market::API_URL}/trades?market=#{base}#{target}"
        end

        def adapt(output, market_pair)
          output.collect do |trade|
            tr = Cryptoexchange::Models::Trade.new
            tr.trade_id  = trade['tid']
            tr.base      = market_pair.base
            tr.target    = market_pair.target
            tr.price     = trade['price']
            tr.amount    = trade['amount']
            tr.type      = trade['side']

            timestamp = DateTime.iso8601(trade['created_at'])
                                .to_time
                                .to_i

            tr.timestamp = timestamp
            tr.payload   = trade
            tr.market    = Omnitrade::Market::NAME
            tr
          end
        end
      end
    end
  end
end
