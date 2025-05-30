{if $product.variation_features_variants}
    {script src="js/addons/product_variations/picker_features.js"}
    <div id="features_{$obj_prefix}{$obj_id}_AOC">
        {$container = "product_detail_page"}
        {$product_url = "products.view"}
        {$show_all_possible_feature_variants = $addons.product_variations.variations_show_all_possible_feature_variants === "YesNo::YES"|enum}
        {$allow_negative_amount = $allow_negative_amount|default:$settings.General.allow_negative_amount === "YesNo::YES"|enum}
        {$is_buy_in_advance = $product.out_of_stock_actions === "OutOfStockActions::BUY_IN_ADVANCE"|enum}
        {$show_out_of_stock_products = $settings.General.show_out_of_stock_products === "YesNo::YES"|enum}

        {if $quick_view}
            {$container = "product_main_info_form_{$obj_prefix}{$quick_view_additional_container}"}
            {$product_url = "products.quick_view?product_id=`$product.product_id`&prev_url=`$current_url`"|trim}
        {/if}

        {if $is_microstore}
            {$product_url = $product_url|fn_link_attach:"is_microstore=Y"}

            {if $product.company_id}
                {$product_url = $product_url|fn_link_attach:"microstore_company_id=`$product.company_id`"}
            {/if}
        {/if}

        {if $product.detailed_params.is_preview}
            {$product_url = $product_url|fn_link_attach:"action=preview"}
        {/if}

        <div class="cm-picker-product-variation-features ty-product-options">
            {$feature_style_dropdown = "\Tygh\Enum\ProductFeatureStyles::DROP_DOWN"|constant}
            {$feature_style_images = "\Tygh\Enum\ProductFeatureStyles::DROP_DOWN_IMAGES"|constant}
            {$feature_style_labels = "\Tygh\Enum\ProductFeatureStyles::DROP_DOWN_LABELS"|constant}
            {$purpose_create_variations = "\Tygh\Addons\ProductVariations\Product\FeaturePurposes::CREATE_VARIATION_OF_CATALOG_ITEM"|constant}

            {foreach $product.variation_features_variants as $feature}
                {$is_feature_default_style = !in_array($feature.feature_style, [$feature_style_images, $feature_style_labels, $feature_style_dropdown])}

                <div class="ty-control-group ty-product-options__item clearfix">
                    {if $feature.feature_style === $feature_style_images}
                        {capture name="variant_images"}
                            {assign var="variant_count" value=0}
                            {assign var="total_variants" value=$feature.variants|@count}
                            {foreach $feature.variants as $variant}
                                {assign var="variant_count" value=$variant_count+1}

                                {if $variant_count <= 4}
                                    {if $variant.showed_product_id}
                                        {$variant_product_id = $variant.showed_product_id}
                                    {else}
                                        {$variant_product_id = $variant.product.product_id}
                                    {/if}

                                    {if $variant_product_id}
                                        {if ($variant.amount || $allow_negative_amount || $is_buy_in_advance || $show_out_of_stock_products) && !$variant.product.disabled}
                                            <a data-ca-target-id="ajax_update_{$product.product_id}" href="{"products.change_variant&variant_id=`$variant_product_id`&ob_id=`$product.product_id`&template=`$template`"|fn_url}"
                                            class="ty-product-options__image--wrapper  cm-ajax"
                                            >
                                        {/if}

                                        {if ($variant.amount || $allow_negative_amount || $is_buy_in_advance || $show_out_of_stock_products) && !$variant.product.disabled}
                                            {$image_class = "ty-product-options__image"}
                                        {else}
                                            {$image_class = "ty-product-variations-image-disabled"}
                                        {/if}

                                        {include file="common/image.tpl"
                                        obj_id="image_feature_variant_{$feature.feature_id}_{$variant.variant_id}_{$obj_prefix}{$obj_id}"
                                        class=$image_class
                                        images=$variant.product.main_pair
                                        image_width=$settings.Thumbnails.product_variant_mini_icon_width
                                        image_height=$settings.Thumbnails.product_variant_mini_icon_height
                                        image_additional_attrs = [
                                        "width" => $settings.Thumbnails.product_variant_mini_icon_width,
                                        "height" => $settings.Thumbnails.product_variant_mini_icon_height
                                        ]
                                        }

                                        {if ($variant.amount || $allow_negative_amount || $is_buy_in_advance || $show_out_of_stock_products) && !$variant.product.disabled}
                                            </a>
                                        {/if}
                                    {/if}
                                {/if}
                            {/foreach}

                            {if $total_variants > 4}
                                <div class="ty-product-options__image--wrapper ty-product-options__image--more">
                                    <div class="ty-product-options__more-colors">
                                        <a href="{$product_url|fn_link_attach:"product_id={$product.product_id}"|fn_url}"
                                        >+{$total_variants-4}</a>
                                    </div>
                                </div>
                            {/if}

                        {/capture}

                        {if $smarty.capture.variant_images|trim}
                            <div class="ty-clear-both">
                                {$smarty.capture.variant_images nofilter}
                            </div>
                        {/if}
                    {/if}
                </div>
            {/foreach}
        </div>
    </div>
{/if}
