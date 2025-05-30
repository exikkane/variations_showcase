
{assign var="obj_id" value=$product.product_id}
{assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id``$settings.ab__device`"}
{assign var="show_price" value=true}
{assign var="show_price_values" value=true}


{include file="common/product_data.tpl" product=$product product_labels_position="left-top" show_labels_in_title=false}

<div class="ut2-gl__item {if $settings.abt__ut2.product_list.decolorate_out_of_stock_products == "YesNo::YES"|enum && $product.amount <= 0} out-of-stock{/if}">

    {hook name="products:product_multicolumns_list"}

    {assign var="form_open" value="form_open_`$obj_id`"}
    {$smarty.capture.$form_open nofilter}
    <div class="ut2-gl__body{if $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.ab__device] === "YesNo::YES"|enum} content-on-hover{/if}{if $settings.abt__ut2.product_list.decolorate_out_of_stock_products == "YesNo::YES"|enum && $product.amount < 1 && $product.out_of_stock_actions != "OutOfStockActions::BUY_IN_ADVANCE"|enum} decolorize{/if}">

        <div class="ut2-gl__image">

            {include file="views/products/components/product_icon.tpl" product=$product image_width=$tbw image_height=$tbh thumbnails_size=$thumbnails_size show_gallery=$show_gallery}

            {if $show_product_labels}
                {capture name="capture_product_labels_`$obj_prefix``$obj_id`"}
                    {hook name="products:product_labels"}
                    {if $show_shipping_label && $product.free_shipping == "YesNo::YES"|enum}
                        {include
                        file="views/products/components/product_label.tpl"
                        label_meta="ty-product-labels__item--shipping"
                        label_text=__("free_shipping")
                        label_mini=$product_labels_mini
                        label_static=$product_labels_static
                        label_rounded=$product_labels_rounded
                        }
                    {/if}
                    {if $show_discount_label && ($product.discount_prc || $product.list_discount_prc) && $show_price_values}
                        {if $product.discount}
                            {$label_text = "{__("save_discount")} <bdi>{$product.discount_prc}%</bdi>"}
                        {else}
                            {$label_text = "{__("save_discount")} <bdi>{$product.list_discount_prc}%</bdi>"}
                        {/if}

                        {include
                        file="views/products/components/product_label.tpl"
                        label_meta="ty-product-labels__item--discount"
                        label_text=$label_text
                        label_mini=$product_labels_mini
                        label_static=$product_labels_static
                        label_rounded=$product_labels_rounded
                        }
                    {/if}
                    {/hook}
                {/capture}
                {$capture_product_labels = "capture_product_labels_`$obj_prefix``$obj_id`"}

                {if $smarty.capture.$capture_product_labels|trim}
                    <div class="ty-product-labels ty-product-labels--{$product_labels_position} {if $product_labels_mini}ty-product-labels--mini{/if} {if $product_labels_static}ty-product-labels--static{/if} cm-reload-{$obj_prefix}{$obj_id}"
                         id="product_labels_update_{$obj_prefix}{$obj_id}">
                        {$smarty.capture.$capture_product_labels nofilter}
                        <!--product_labels_update_{$obj_prefix}{$obj_id}--></div>
                {/if}
            {/if}

            <div class="ut2-w-c-q__buttons {if $settings.abt__ut2.product_list.hover_buttons_w_c_q[$settings.ab__device] === "YesNo::YES"|enum}w_c_q-hover{/if}"
                 {if $smarty.capture.abt__service_buttons_id}id="{$smarty.capture.abt__service_buttons_id}"{/if}>

                {if !$quick_view && $settings.Appearance.enable_quick_view == "YesNo::YES"|enum && $settings.ab__device === "desktop"}
                    {include file="views/products/components/quick_view_link.tpl" quick_nav_ids=$quick_nav_ids}
                {/if}

                {if $addons.wishlist.status == "ObjectStatuses::ACTIVE"|enum && !$hide_wishlist_button && $settings.abt__ut2.product_list.button_wish_list_view[$settings.ab__device] === "YesNo::YES"|enum && !$is_wishlist}
                    {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text"}

                {elseif $addons.wishlist.status == "ObjectStatuses::ACTIVE"|enum && !$hide_wishlist_button && $settings.abt__ut2.product_list.button_wish_list_view[$settings.ab__device] === "YesNo::YES"|enum && $is_wishlist}
                    {include file="addons/wishlist/views/wishlist/components/remove_from_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text"}
                {/if}

                {if $settings.General.enable_compare_products == "YesNo::YES"|enum && !$hide_compare_list_button && $settings.abt__ut2.product_list.button_compare_view[$settings.ab__device] === "YesNo::YES"|enum || $product.feature_comparison == "YesNo::YES"|enum && $settings.abt__ut2.product_list.button_compare_view[$settings.ab__device] === "YesNo::YES"|enum}
                    {include file="buttons/add_to_compare_list.tpl" product_id=$product.product_id}
                {/if}
                <!--{$smarty.capture.abt__service_buttons_id}--></div>

            {if $show_brand_logo && $settings.abt__ut2.general.brand_feature_id > 0}
                {$b_feature=$product.abt__ut2_features[$settings.abt__ut2.general.brand_feature_id]}
                {if $b_feature.variants[$b_feature.variant_id].image_pairs}
                    <div class="brand-img">
                        {include file="common/image.tpl" image_height=20 images=$b_feature.variants[$b_feature.variant_id].image_pairs no_ids=true}
                    </div>
                {/if}
            {/if}
        </div>

        {capture name="product_multicolumns_list_control_data_wrapper"}
            {if $show_add_to_cart && $button_type_add_to_cart != 'none'}

                {assign var="qty" value="qty_`$obj_id`"}
                <div class="ut2-gl__control {if $settings.abt__ut2.product_list.$tmpl.show_buttons_on_hover[$settings.ab__device] === "YesNo::YES"|enum} hidden{/if}{if $settings.abt__ut2.product_list.$tmpl.show_qty[$settings.ab__device] === "YesNo::YES"|enum && $smarty.capture.$qty|strip_tags:false|replace:"&nbsp;":""|trim|strlen} ut2-view-qty{/if}{if $button_type_add_to_cart != 'none'} {$button_type_add_to_cart}{/if}">

                    {capture name="product_multicolumns_list_control_data"}
                        {hook name="products:product_multicolumns_list_control"}
                        {$add_to_cart = "add_to_cart_`$obj_id`"}
                        {$smarty.capture.$add_to_cart nofilter}

                        {if $show_qty && $smarty.capture.$qty|strip_tags:false|replace:"&nbsp;":""|trim|strlen}
                            {$smarty.capture.$qty nofilter}
                        {/if}
                        {/hook}
                    {/capture}
                    {$smarty.capture.product_multicolumns_list_control_data nofilter}
                </div>
            {/if}
        {/capture}

        {if $settings.abt__ut2.product_list.price_position_top|default:{"YesNo::YES"|enum} == "YesNo::YES"|enum}
        {if $button_type_add_to_cart == 'icon' || $button_type_add_to_cart == 'icon_button'}
        <div class="ut2-gl__mix-price-and-button {if $show_qty}qty-wrap{/if}">
            {/if}

            <div class="ut2-gl__price{if $product.price == 0} ut2-gl__no-price{/if}    pr-{$settings.abt__ut2.product_list.price_display_format}{if $product.list_discount || $product.discount} pr-color{/if}"
                 style="min-height: {$smarty.capture.abt__ut2_pr_block_height  nofilter}px;">
                {hook name="products:list_price_block"}
                <div>
                            <span class="{if $product.zero_price_action !== "A"}cm-reload-{$obj_prefix}{$obj_id}{/if} ty-price-update"
                                  id="price_update_{$obj_prefix}{$obj_id}">
        <input type="hidden"
               name="appearance[show_price_values]"
               value="{$show_price_values}"/>
        <input type="hidden"
               name="appearance[show_price]"
               value="{$show_price}"/>
        {if $show_price_values}
                                {if $show_price}
                                {hook name="products:prices_block"}
    {if $auth.tax_exempt === "{"YesNo::NO"|enum}" || !$product.clean_price}
                    {$price = $product.price}
    {else}
        {$price = $product.clean_price}
    {/if}
    {if $product.price|floatval || $product.zero_price_action == "P" || ($hide_add_to_cart_button == "YesNo::YES"|enum && $product.zero_price_action == "A")}
    <span class="ty-price{if !$product.price|floatval && !$product.zero_price_action} hidden{/if}" id="line_discounted_price_{$obj_prefix}{$obj_id}">{include file="common/price.tpl" value=$product.price span_id="discounted_price_`$obj_prefix``$obj_id`" class="ty-price-num" live_editor_name="product:price:{$product.product_id}" live_editor_phrase=$product.base_price}</span>
                {elseif $product.zero_price_action == "A" && $show_add_to_cart}
                    {$base_currency = $currencies[$smarty.const.CART_PRIMARY_CURRENCY]}
                    <div class="ty-price-curency-input">
                        <input
                            type="text"
                            name="product_data[{$obj_id}][price]"
                            class="ty-price-curency__input cm-numeric"
                            title="{__("enter_your_price")}"
                            data-a-sign="{$base_currency.symbol nofilter}"
                            data-a-dec="{if $base_currency.decimal_separator}{$base_currency.decimal_separator nofilter}{else}.{/if}"
                            data-a-sep="{if $base_currency.thousands_separator}{$base_currency.thousands_separator nofilter}{else},{/if}"
                            data-p-sign="{if $base_currency.after === "YesNo::YES"|enum}s{else}p{/if}"
                            data-m-dec="{$base_currency.decimals}"
                            size="10"
                            value=""
                        />
                    <i class="ty-icon ty-icon-help-circle cm-tooltip" title="{__("enter_your_price")}"></i>
                    </div>
                    </span>

                {elseif $product.zero_price_action == "R"}
    <span class="ty-no-price">{__("contact_us_for_price")}</span>
        {$show_qty = false}
    {/if}
    {/hook}
    {/if}
{elseif $settings.Checkout.allow_anonymous_shopping == "hide_price_and_add_to_cart" && !$auth.user_id}
<span class="ty-price">{__("sign_in_to_view_price")}</span>
{/if}
    <!--price_update_{$obj_prefix}{$obj_id}--></span>

    {if $settings.abt__ut2.product_list.show_you_save[$settings.ab__device] === "short"}<span>{/if}
    {if $show_price_values && $show_old_price}
    <span class="cm-reload-{$obj_prefix}{$obj_id}" id="old_price_update_{$obj_prefix}{$obj_id}">
            <input type="hidden" name="appearance[show_old_price]" value="{$show_old_price}" />
            {hook name="products:old_price"}
            {if $product.discount}
                {if !$product.included_tax}
                    <span class="ty-list-price" id="line_old_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.original_price|default:$product.base_price - $product.tax_value span_id="old_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
                {else}
                    <span class="ty-list-price" id="line_old_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.original_price|default:$product.base_price span_id="old_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
                {/if}
            {elseif $product.list_discount}
                {if !$product.included_tax}
                <span class="ty-list-price" id="line_list_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.list_price - $product.tax_value span_id="list_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
                {else}
                    <span class="ty-list-price" id="line_list_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.list_price span_id="list_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
            {/if}
            {/if}
            {/hook}
        <!--old_price_update_{$obj_prefix}{$obj_id}--></span>
    {/if}

                                {if $show_price_values && $show_list_discount}
        <span class="{if !$details_page && $settings.abt__ut2.product_list.show_you_save[$settings.ab__device] === "short" || $details_page && $settings.abt__ut2.products.view.show_you_save[$settings.ab__device] === "short"}ut2-sld-short{/if} cm-reload-{$obj_prefix}{$obj_id}" id="line_discount_update_{$obj_prefix}{$obj_id}">
            <input type="hidden" name="appearance[show_price_values]" value="{$show_price_values}" />
            <input type="hidden" name="appearance[show_list_discount]" value="{$show_list_discount}" />
            {if $product.discount}
<span class="ty-list-price ty-save-price" id="line_discount_value_{$obj_prefix}{$obj_id}">{if !$details_page && $settings.abt__ut2.product_list.show_you_save[$settings.ab__device] === "full" || $details_page && $settings.abt__ut2.products.view.show_you_save[$settings.ab__device] === "full"}{__("you_save")}: {include file="common/price.tpl" value=$product.discount span_id="discount_value_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}{else}{if $product.discount}{if $product.discount_prc > 0}-{$product.discount_prc}%{/if}{else}{if $product.list_discount_prc > 0}-{$product.list_discount_prc}%{/if}{/if}{/if}</span>
            {elseif $product.list_discount}
                <span class="ty-list-price ty-save-price" id="line_discount_value_{$obj_prefix}{$obj_id}">{if !$details_page && $settings.abt__ut2.product_list.show_you_save[$settings.ab__device] === "full" || $details_page && $settings.abt__ut2.products.view.show_you_save[$settings.ab__device] === "full"}{__("you_save")}: {include file="common/price.tpl" value=$product.list_discount span_id="discount_value_`$obj_prefix``$obj_id`"}{else}{if $product.discount}{if $product.discount_prc > 0}-{$product.discount_prc}%{/if}{else}{if $product.list_discount_prc > 0}-{$product.list_discount_prc}%{/if}{/if}{/if}</span>
            {/if}
        <!--line_discount_update_{$obj_prefix}{$obj_id}--></span>
    {/if}
                                {if $settings.abt__ut2.product_list.show_you_save[$settings.ab__device] === "short"}</span>{/if}
                        </div>
                    {if $show_price_values
&& $show_clean_price
&& $settings.Appearance.show_prices_taxed_clean === "YesNo::YES"|enum
&& $auth.tax_exempt !== "YesNo::YES"|enum
&& $product.taxed_price
}
        <span class="cm-reload-{$obj_prefix}{$obj_id}" id="clean_price_update_{$obj_prefix}{$obj_id}">
            <input type="hidden" name="appearance[show_price_values]" value="{$show_price_values}" />
            <input type="hidden" name="appearance[show_clean_price]" value="{$show_clean_price}" />
            {if $product.clean_price != $product.taxed_price && $product.included_tax}
                <span class="ty-list-price" id="line_product_price_{$obj_prefix}{$obj_id}">({include file="common/price.tpl" value=$product.taxed_price span_id="product_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"} {__("inc_tax")})</span>
            {elseif $product.clean_price != $product.taxed_price && !$product.included_tax}
                <span class="ty-list-price ty-tax-include">({__("including_tax")})</span>
            {/if}
        <!--clean_price_update_{$obj_prefix}{$obj_id}--></span>
    {/if}
                    {/hook}
                </div>


                {if $settings.abt__ut2.product_list.$tmpl.show_qty[$settings.ab__device] === "YesNo::NO"|enum || $settings.ab__device === "desktop"}
                    {if $button_type_add_to_cart == 'icon' || $button_type_add_to_cart == 'icon_button'}
                        {if $smarty.capture.product_multicolumns_list_control_data|trim}
                            {$smarty.capture.product_multicolumns_list_control_data_wrapper nofilter}
                        {/if}
                    {/if}
                {/if}

                {if $button_type_add_to_cart == 'icon' || $button_type_add_to_cart == 'icon_button'}
                    </div>
                {/if}
            {/if}

            <div class="ut2-gl__content{if $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.ab__device] === "YesNo::YES"|enum} content-on-hover{/if}" style="min-height:{$smarty.capture.abt__ut2_gl_content_height nofilter}px;">

                <div class="ut2-gl__name">
                    {if $item_number == "YesNo::YES"|enum}
<span class="item-number">{$cur_number}.&nbsp;</span>
    {math equation="num + 1" num=$cur_number assign="cur_number"}
{/if}

{hook name="products:product_name"}

{if $hide_links}<strong>{else}<a href="{"products.view?product_id=`$product.product_id`"|fn_url}" class="product-title" title="{$product.product|strip_tags}" {live_edit name="product:product:{$product.product_id}" phrase=$product.product}>{/if}{if $show_labels_in_title}{hook name="products:dotd_product_label"}{/hook}{/if}{$product.product nofilter}{if $hide_links}</strong>{else}</a>{/if}

{/hook}
</div>

{if $product.product_code}
    {if $show_sku}
        {hook name="products:abt__sku"}
        <div class="ty-control-group ty-sku-item cm-hidden-wrapper{if !$product.product_code} hidden{/if}" id="sku_update_{$obj_prefix}{$obj_id}">
            <input type="hidden" name="appearance[show_sku]" value="{$show_sku}" />
            {if $show_sku_label}
                <label class="ty-control-group__label" id="sku_{$obj_prefix}{$obj_id}">{__("sku")}:</label>
            {/if}
            <div class="ty-control-group__item cm-reload-{$obj_prefix}{$obj_id} ut2_copy" title="{__("copy")}" id="product_code_{$obj_prefix}{$obj_id}">
                <i class="ut2-icon-copy"></i>
                <div class="ut2--sku-text">{$product.product_code}</div>
        <!--product_code_{$obj_prefix}{$obj_id}-->
        </div>
        </div>
        {/hook}
    {/if}
{/if}

{include file="blocks/product_list_templates/components/average_rating.tpl"}

{if $show_features || $show_descr}
    {if empty($block.properties) && $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.ab__device] === "YesNo::NO"|enum && !$products_scroller}
    <div class="ut2-gl__bottom">
        {hook name="products:additional_info_before"}{/hook}
        {if $show_descr && $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.ab__device] !== "features_and_variations"}
            {if $show_descr}
                {if $product.short_description}
                <div class="product-description" {live_edit name="product:short_description:{$product.product_id}"}>{$product.short_description|strip_tags nofilter}</div>
                {else}
                <div class="product-description" {live_edit name="product:full_description:{$product.product_id}" phrase=$product.full_description}>{$product.full_description|strip_tags|truncate:300 nofilter}</div>
                {/if}
            {/if}
        {/if}

        {hook name="products:ab__s_pictograms_pos_1"}{/hook}

        {if $product.abt__ut2_features && !$hide_features}
        <div class="ut2-gl__feature">
            {hook name="products:product_features"}
            {if $show_features && $product.abt__ut2_features}
                {$max_features=$settings.abt__ut2.product_list.max_features[$settings.ab__device]|default:5}
            <div class="cm-reload-{$obj_prefix}{$obj_id}" id="product_data_features_update_{$obj_prefix}{$obj_id}">
            <input type="hidden" name="appearance[show_features]" value="{$show_features}" />
            {include file="views/products/components/product_features_short_list.tpl" features=$product.abt__ut2_features|array_slice:0:$max_features no_container=true}
        <!--product_data_features_update_{$obj_prefix}{$obj_id}--></div>
    {/if}
{/hook}
                                </div>
                            {/if}

                            {hook name="products:ab__s_pictograms_pos_2"}{/hook}
                        </div>
                    {/if}
                {/if}

                {if 1}
                    <div class="ut2-gl__amount">
                        {hook name="products:product_amount"}
                            {if $product.is_edp != "YesNo::YES"|enum && $settings.General.inventory_tracking !== "YesNo::NO"|enum}
                                {$is_tracking_product = $settings.General.default_tracking !== "ProductTracking::DO_NOT_TRACK"|enum && $product.tracking !== "ProductTracking::DO_NOT_TRACK"|enum || $product.tracking !== "ProductTracking::DO_NOT_TRACK"|enum}
                                <div class="cm-reload-{$obj_prefix}{$obj_id} stock-wrap" id="product_amount_update_{$obj_prefix}{$obj_id}">
                                    <input type="hidden" name="appearance[show_product_amount]" value="{$show_product_amount}" />
                                    {if !$product.hide_stock_info}
                                        {if $settings.Appearance.in_stock_field == "YesNo::YES"|enum}
                                            {if $is_tracking_product}
                                                {if ($product_amount > 0 && $product_amount >= $product.min_qty) || $details_page}
                                                    {if (
$product_amount > 0
&& $product_amount >= $product.min_qty
|| $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum
)
}
                            <div class="product-list-field">
                                <span class="ty-qty-in-stock ty-control-group__item">{__("availability")}:</span>
                                <span id="qty_in_stock_{$obj_prefix}{$obj_id}" class="ty-qty-in-stock ty-control-group__item">
                                    {if $product_amount > 0}
                                    	{$product_amount}&nbsp;{__("items")}
                                    {else}
                                    	<span class="on_backorder">{__("on_backorder")}</span>
                                    {/if}
                                </span>
                            </div>
                        {elseif $allow_negative_amount !== "YesNo::YES"|enum}
                            <div class="ty-control-group product-list-field">
                                {if $show_amount_label}
                                    <label class="ty-control-group__label">{__("in_stock")}:</label>
                                {/if}
                                <span class="ty-qty-out-of-stock ty-control-group__item">{$out_of_stock_text}</span>
                            </div>
                        {/if}
                    {else}
                        <div class="ty-control-group product-list-field">
                            {if $show_amount_label}
                                <label class="ty-control-group__label">{__("availability")}:</label>
                            {/if}
                            <span class="ty-qty-out-of-stock ty-control-group__item" id="out_of_stock_info_{$obj_prefix}{$obj_id}">{$out_of_stock_text}</span>
                        </div>
                    {/if}
                {/if}
            {else}
                {if (
$product_amount > 0
&& $product_amount >= $product.min_qty
|| $product.tracking == "ProductTracking::DO_NOT_TRACK"|enum
)
&& $is_tracking_product
&& $allow_negative_amount !== "YesNo::YES"|enum
|| $is_tracking_product
&& (
$allow_negative_amount === "YesNo::YES"|enum
|| $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum
)
}
                    <div class="ty-control-group product-list-field">
                        {if $show_amount_label && $settings.Appearance.in_stock_field == "YesNo::YES"|enum }
                            <label class="ty-control-group__label">{__("availability")}:</label>
                        {/if}
                        <span class="ty-qty-in-stock ty-control-group__item" id="in_stock_info_{$obj_prefix}{$obj_id}">
                            {if $product_amount > 0}
                                {__("in_stock")}
                            {else}
                                {if $details_page}<span class="on_backorder">{/if}{__("on_backorder")}</span>
                            {/if}
                        </span>
                    </div>
                {elseif (
$product_amount <= 0
|| $product_amount < $product.min_qty
)
&& $is_tracking_product
&& $allow_negative_amount !== "YesNo::YES"|enum
}
                    <div class="ty-control-group product-list-field">
                        {if $show_amount_label}
                            <label class="ty-control-group__label">{__("availability")}:</label>
                        {/if}
                        <span class="ty-qty-out-of-stock ty-control-group__item" id="out_of_stock_info_{$obj_prefix}{$obj_id}">{$out_of_stock_text}</span>
                    </div>
                {/if}
            {/if}
        {/if}
    <!--product_amount_update_{$obj_prefix}{$obj_id}--></div>

    {if ($product.avail_since > $smarty.const.TIME) && $details_page}
        {include file="common/coming_soon_notice.tpl" avail_date=$product.avail_since add_to_cart=$product.out_of_stock_actions}
    {/if}
{/if}
{/hook}

                    </div>
                {/if}

                {if $settings.abt__ut2.product_list.price_position_top|default:{"YesNo::YES"|enum} == "YesNo::NO"|enum}
                <div class="ut2-gl__price-wrap">
                    {if $button_type_add_to_cart == 'icon' || $button_type_add_to_cart == 'icon_button'}
                    <div class="ut2-gl__mix-price-and-button {if $show_qty}qty-wrap{/if}">
                        {/if}

                        <div class="ut2-gl__price{if $product.price == 0} ut2-gl__no-price{/if}    pr-{$settings.abt__ut2.product_list.price_display_format}{if $product.list_discount || $product.discount} pr-color{/if}{if $settings.abt__ut2.product_list.show_you_save[$settings.ab__device] === "short"} ut2-sld-short{/if}">
                            {hook name="products:list_price_block"}
<div>
<span class="{if $product.zero_price_action !== "A"}cm-reload-{$obj_prefix}{$obj_id}{/if} ty-price-update" id="price_update_{$obj_prefix}{$obj_id}">
        <input type="hidden" name="appearance[show_price_values]" value="{$show_price_values}" />
        <input type="hidden" name="appearance[show_price]" value="{$show_price}" />
        {if $show_price_values}
    {if $show_price}
        {hook name="products:prices_block"}
        {if $auth.tax_exempt === "{"YesNo::NO"|enum}" || !$product.clean_price}
            {$price = $product.price}
        {else}
            {$price = $product.clean_price}
        {/if}
        {if $product.price|floatval || $product.zero_price_action == "P" || ($hide_add_to_cart_button == "YesNo::YES"|enum && $product.zero_price_action == "A")}
        <span class="ty-price{if !$product.price|floatval && !$product.zero_price_action} hidden{/if}" id="line_discounted_price_{$obj_prefix}{$obj_id}">{include file="common/price.tpl" value=$product.price span_id="discounted_price_`$obj_prefix``$obj_id`" class="ty-price-num" live_editor_name="product:price:{$product.product_id}" live_editor_phrase=$product.base_price}</span>
                {elseif $product.zero_price_action == "A" && $show_add_to_cart}
                    {$base_currency = $currencies[$smarty.const.CART_PRIMARY_CURRENCY]}
                    <div class="ty-price-curency-input">
                        <input
                            type="text"
                            name="product_data[{$obj_id}][price]"
                            class="ty-price-curency__input cm-numeric"
                            title="{__("enter_your_price")}"
                            data-a-sign="{$base_currency.symbol nofilter}"
                            data-a-dec="{if $base_currency.decimal_separator}{$base_currency.decimal_separator nofilter}{else}.{/if}"
                            data-a-sep="{if $base_currency.thousands_separator}{$base_currency.thousands_separator nofilter}{else},{/if}"
                            data-p-sign="{if $base_currency.after === "YesNo::YES"|enum}s{else}p{/if}"
                            data-m-dec="{$base_currency.decimals}"
                            size="10"
                            value=""
                        />
                    <i class="ty-icon ty-icon-help-circle cm-tooltip" title="{__("enter_your_price")}"></i>
                    </div>
                    </span>

                {elseif $product.zero_price_action == "R"}
        <span class="ty-no-price">{__("contact_us_for_price")}</span>
            {$show_qty = false}
        {/if}
        {/hook}
    {/if}
{elseif $settings.Checkout.allow_anonymous_shopping == "hide_price_and_add_to_cart" && !$auth.user_id}
<span class="ty-price">{__("sign_in_to_view_price")}</span>
{/if}
<!--price_update_{$obj_prefix}{$obj_id}--></span>

{if $settings.abt__ut2.product_list.show_you_save[$settings.ab__device] === "short"}<span>{/if}
{if $show_price_values && $show_old_price}
<span class="cm-reload-{$obj_prefix}{$obj_id}" id="old_price_update_{$obj_prefix}{$obj_id}">
            <input type="hidden" name="appearance[show_old_price]" value="{$show_old_price}" />
            {hook name="products:old_price"}
            {if $product.discount}
                {if !$product.included_tax}
                    <span class="ty-list-price" id="line_old_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.original_price|default:$product.base_price - $product.tax_value span_id="old_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
                {else}
                    <span class="ty-list-price" id="line_old_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.original_price|default:$product.base_price span_id="old_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
                {/if}
            {elseif $product.list_discount}
                {if !$product.included_tax}
                <span class="ty-list-price" id="line_list_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.list_price - $product.tax_value span_id="list_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
                {else}
                    <span class="ty-list-price" id="line_list_price_{$obj_prefix}{$obj_id}"><span class="ty-strike">{include file="common/price.tpl" value=$product.list_price span_id="list_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}</span></span>
            {/if}
            {/if}
            {/hook}
        <!--old_price_update_{$obj_prefix}{$obj_id}--></span>
    {/if}

                                        {if $show_price_values && $show_list_discount}
        <span class="{if !$details_page && $settings.abt__ut2.product_list.show_you_save[$settings.ab__device] === "short" || $details_page && $settings.abt__ut2.products.view.show_you_save[$settings.ab__device] === "short"}ut2-sld-short{/if} cm-reload-{$obj_prefix}{$obj_id}" id="line_discount_update_{$obj_prefix}{$obj_id}">
            <input type="hidden" name="appearance[show_price_values]" value="{$show_price_values}" />
            <input type="hidden" name="appearance[show_list_discount]" value="{$show_list_discount}" />
            {if $product.discount}
<span class="ty-list-price ty-save-price" id="line_discount_value_{$obj_prefix}{$obj_id}">{if !$details_page && $settings.abt__ut2.product_list.show_you_save[$settings.ab__device] === "full" || $details_page && $settings.abt__ut2.products.view.show_you_save[$settings.ab__device] === "full"}{__("you_save")}: {include file="common/price.tpl" value=$product.discount span_id="discount_value_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"}{else}{if $product.discount}{if $product.discount_prc > 0}-{$product.discount_prc}%{/if}{else}{if $product.list_discount_prc > 0}-{$product.list_discount_prc}%{/if}{/if}{/if}</span>
            {elseif $product.list_discount}
                <span class="ty-list-price ty-save-price" id="line_discount_value_{$obj_prefix}{$obj_id}">{if !$details_page && $settings.abt__ut2.product_list.show_you_save[$settings.ab__device] === "full" || $details_page && $settings.abt__ut2.products.view.show_you_save[$settings.ab__device] === "full"}{__("you_save")}: {include file="common/price.tpl" value=$product.list_discount span_id="discount_value_`$obj_prefix``$obj_id`"}{else}{if $product.discount}{if $product.discount_prc > 0}-{$product.discount_prc}%{/if}{else}{if $product.list_discount_prc > 0}-{$product.list_discount_prc}%{/if}{/if}{/if}</span>
            {/if}
        <!--line_discount_update_{$obj_prefix}{$obj_id}--></span>
    {/if}
                                        {if $settings.abt__ut2.product_list.show_you_save[$settings.ab__device] === "short"}</span>{/if}
                                </div>
                            {if $show_price_values
&& $show_clean_price
&& $settings.Appearance.show_prices_taxed_clean === "YesNo::YES"|enum
&& $auth.tax_exempt !== "YesNo::YES"|enum
&& $product.taxed_price
}
        <span class="cm-reload-{$obj_prefix}{$obj_id}" id="clean_price_update_{$obj_prefix}{$obj_id}">
            <input type="hidden" name="appearance[show_price_values]" value="{$show_price_values}" />
            <input type="hidden" name="appearance[show_clean_price]" value="{$show_clean_price}" />
            {if $product.clean_price != $product.taxed_price && $product.included_tax}
                <span class="ty-list-price" id="line_product_price_{$obj_prefix}{$obj_id}">({include file="common/price.tpl" value=$product.taxed_price span_id="product_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"} {__("inc_tax")})</span>
            {elseif $product.clean_price != $product.taxed_price && !$product.included_tax}
                <span class="ty-list-price ty-tax-include">({__("including_tax")})</span>
            {/if}
        <!--clean_price_update_{$obj_prefix}{$obj_id}--></span>
    {/if}
                            {/hook}
                        </div>
                        {/if}

                        {if $settings.abt__ut2.product_list.$tmpl.show_buttons_on_hover[$settings.ab__device] === "YesNo::NO"|enum
&& ($button_type_add_to_cart === 'text' || $button_type_add_to_cart === 'icon_and_text')
||
$settings.abt__ut2.product_list.price_position_top === "YesNo::NO"|enum
&& ($button_type_add_to_cart === 'icon' || $button_type_add_to_cart === 'icon_button')
||
$settings.abt__ut2.product_list.price_position_top === "YesNo::YES"|enum
&& $settings.abt__ut2.product_list.$tmpl.show_qty[$settings.ab__device] === "YesNo::YES"|enum
&& $settings.ab__device !== "desktop"
}

                            {if $smarty.capture.product_multicolumns_list_control_data|trim}
                                {$smarty.capture.product_multicolumns_list_control_data_wrapper nofilter}
                            {/if}
                        {/if}

                        {if $settings.abt__ut2.product_list.price_position_top === "YesNo::NO"|enum}
                        {if $button_type_add_to_cart === 'icon' || $button_type_add_to_cart === 'icon_button'}
                    </div>
                    {/if}
                </div>
                {/if}

            </div>{* End "ut2-gl__content" conteiner *}

            {hook name="products:ab__mv_vendor_info"}{/hook}

            {if $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.ab__device] === "YesNo::YES"|enum && $settings.ab__device !== "mobile" && !$products_scroller}
                <div class="ut2-gl__bottom">

                    {if $settings.abt__ut2.product_list.$tmpl.show_buttons_on_hover[$settings.ab__device] === "YesNo::YES"|enum
&& ($button_type_add_to_cart === 'text' || $button_type_add_to_cart === 'icon_and_text')}

                        {if $smarty.capture.product_multicolumns_list_control_data|trim}
                            {$smarty.capture.product_multicolumns_list_control_data_wrapper nofilter}
                        {/if}
                    {/if}

                    {hook name="products:additional_info"}{/hook}
                    {hook name="products:additional_info_before"}{/hook}

                    {if $show_descr && $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.ab__device] != "features_and_variations"}
                        {if $show_descr}
        {if $product.short_description}
            <div class="product-description" {live_edit name="product:short_description:{$product.product_id}"}>{$product.short_description|strip_tags nofilter}</div>
        {else}
            <div class="product-description" {live_edit name="product:full_description:{$product.product_id}" phrase=$product.full_description}>{$product.full_description|strip_tags|truncate:300 nofilter}</div>
        {/if}
    {/if}
                    {/if}

                    {hook name="products:ab__s_pictograms_pos_1"}{/hook}

                    {if $show_features and $product.abt__ut2_features && !$hide_features}
                        <div class="ut2-gl__feature">
                            {hook name="products:product_features"}
    {if $show_features && $product.abt__ut2_features}
        {$max_features=$settings.abt__ut2.product_list.max_features[$settings.ab__device]|default:5}
        <div class="cm-reload-{$obj_prefix}{$obj_id}" id="product_data_features_update_{$obj_prefix}{$obj_id}">
            <input type="hidden" name="appearance[show_features]" value="{$show_features}" />
            {include file="views/products/components/product_features_short_list.tpl" features=$product.abt__ut2_features|array_slice:0:$max_features no_container=true}
        <!--product_data_features_update_{$obj_prefix}{$obj_id}--></div>
    {/if}
{/hook}
                        </div>
                    {/if}

                    {hook name="products:ab__s_pictograms_pos_2"}{/hook}
                    {hook name="products:additional_info_after"}{/hook}
                </div>
            {/if}
        </div>
    {hook name="products:product_list_form_close_tag"}
    {assign var="form_close" value="form_close_`$obj_id`"}
    {$smarty.capture.$form_close nofilter}
    {/hook}

    {/hook}
</div>