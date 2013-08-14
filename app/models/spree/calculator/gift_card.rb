require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    class GiftCard < Calculator

      def self.description
        Spree.t(:gift_card_calculator)
      end

      def compute(order, gift_card)
        # Ensure a negative amount which does not exceed the sum of the order's item_total, ship_total, and 
        # tax_total, minus other credits.
        credits = order.adjustments.select{|a|a.amount < 0 && a.originator_type != 'Spree::GiftCard'}.map(&:amount).sum
        # added order.total to avoid subtracting past zero when multiple cards are used
        [(order.item_total + order.ship_total + order.tax_total + credits), gift_card.current_value, order.total].min * -1
      end

    end
  end
end
