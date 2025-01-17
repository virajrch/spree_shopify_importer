module SpreeShopifyImporter
  module DataSavers
    module Variants
      class VariantBase < BaseDataSaver
        delegate :attributes, :option_value_ids, :track_inventory?,
                 :backorderable?, :stock_location, :inventory_quantity, to: :parser

        private

        def add_option_values
          @spree_variant.assign_attributes(option_value_ids: option_value_ids)
        end

        def set_stock_data
          @spree_variant.update(track_inventory: track_inventory?)
          stock_item = @spree_variant.stock_items.find_by(stock_location: stock_location)
          stock_item.update(backorderable: backorderable?) rescue nil
          stock_item.update_column(:count_on_hand, inventory_quantity) if track_inventory? rescue nil
        end

        def assing_spree_variant_to_data_feed
          @shopify_data_feed.update(spree_object: @spree_variant)
        end

        def create_spree_image
          SpreeShopifyImporter::Importers::ImageImporterJob.perform_now(@shopify_image,
                                                                          @shopify_data_feed,
                                                                          @spree_variant)
        end

        def parser
          @parser ||= SpreeShopifyImporter::DataParsers::Variants::BaseData.new(shopify_variant, @spree_product)
        end

        def shopify_variant
          ShopifyAPI::Variant.new(data_feed)
        end
      end
    end
  end
end
