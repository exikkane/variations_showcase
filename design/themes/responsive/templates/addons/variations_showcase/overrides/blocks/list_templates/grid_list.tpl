{strip}
{if $products}
{$tmpl='products_multicolumns'}

{$show_labels_in_title = false}

{if $products_scroller || $banner.abt__ut2_products_template === "grid_items"}
    {$show_gallery = false}
{else}
    {$show_gallery = $settings.abt__ut2.product_list.{$tmpl}.show_gallery.{$settings.ab__device} !== "YesNo::NO"|enum}
{/if}

{$button_type_add_to_cart = $settings.abt__ut2.product_list.$tmpl.show_button_add_to_cart[$settings.ab__device]}

{include file="blocks/product_list_templates/components/show_features_conditions.tpl"}
{include file="blocks/product_list_templates/components/grid_list_settings.tpl"}

{* Thumb *}
{if !empty($block.properties.thumbnail_width) && $settings.ab__device === "desktop"}
    {assign var="tbw" value=$block.properties.thumbnail_width}
{else}
    {assign var="tbw" value=$settings.abt__ut2.product_list.$tmpl.image_width[$settings.ab__device]|default:$settings.Thumbnails.product_lists_thumbnail_width}
{/if}
{if !empty($block.properties.abt__ut2_thumbnail_height) && $settings.ab__device === "desktop"}
    {assign var="tbh" value=$block.properties.abt__ut2_thumbnail_height}
{else}
    {assign var="tbh" value=$settings.abt__ut2.product_list.$tmpl.image_height[$settings.ab__device]|default:$settings.Thumbnails.product_lists_thumbnail_height}
{/if}

{if !($ab__add_ajax_loading_button && $smarty.const.AJAX_REQUEST)}
    {script src="js/tygh/exceptions.js"}
{/if}

{if !$no_pagination}
    {include file="common/pagination.tpl"}
{/if}

{if !$no_sorting}
    {include file="views/products/components/sorting.tpl"}
{/if}

{if !$show_empty && !$products_scroller}
    {split data=$products size=$columns|default:"2" assign="splitted_products"}
{else}
    {split data=$products size=$columns|default:"2" assign="splitted_products" skip_complete=true}
{/if}

{math equation="100 / x" x=$columns|default:"2" assign="cell_width"}
{if $item_number == "YesNo::YES"|enum}
    {assign var="cur_number" value=1}
{/if}

{* FIXME: Don't move this file *}
{script src="js/tygh/product_image_gallery.js"}

{if $settings.Appearance.enable_quick_view == "YesNo::YES"|enum && $settings.ab__device !== "mobile"}
    {$quick_nav_ids = $products|fn_fields_from_multi_level:"product_id":"product_id"}
{/if}

{if $products_scroller}
{$id="simple_products_scroller_{$obj_prefix}"}
<div class="grid-list {if $block.properties.item_quantity}ut2-gl__simple-sroller{/if} ut2-scroll-container {$show_custom_class}" id="{$id}" style="
        --gl-lines-in-name-product: {$settings.abt__ut2.product_list.$tmpl.lines_number_in_name_product[$settings.ab__device]};
        --gl-cols: {$block.properties.item_quantity|default:$columns};
        --gl-item-default-height: {$smarty.capture.abt__ut2_gl_item_height nofilter};
{if $tbh}--gl-thumbs-height: {$tbh}px;{/if}
        {if $tbw}--gl-thumbs-width: {$tbw}px;{/if}">
    <button class="ut2-scroll-left"><span class="ty-icon ty-icon-left-open-thin"></span></button>
    {else}
    <div class="grid-list ut2-gl{if $ab__add_ajax_loading_button} ut2-load-more-wrap{/if} {$show_custom_class}" style="
            --gl-lines-in-name-product: {$settings.abt__ut2.product_list.$tmpl.lines_number_in_name_product[$settings.ab__device]};
            --gl-cols: {$block.properties.item_quantity|default:$columns};
            --gl-item-default-height: {$smarty.capture.abt__ut2_gl_item_height nofilter};
    {if $tbh}--gl-thumbs-height: {$tbh}px;{/if}
            {if $tbw}--gl-thumbs-width: {$tbw}px;{/if}">
        {/if}

        {if $ut2_load_more}
        {include file="common/abt__ut2_pagination.tpl" type="`$runtime.controller`_`$runtime.mode`" position="top" object="products"}
        {else}
        <div class="{if !($ab__add_ajax_loading_button)}{if !$products_scroller}ut2-gl__wrap{elseif $block.properties.item_quantity}ut2-gl__simple-sroller-wrap ut2-scroll-content{else}ut2-scroll-content{/if}{/if}{if $ab__add_ajax_loading_button} grid-list__load-more{/if}">
            {/if}

            {foreach from=$splitted_products item="sproducts" name="sprod"}
                {foreach from=$sproducts item="product" name="sproducts"}
                    <div class="ty-column{if $products_scroller && $block.properties.item_quantity}{$block.properties.item_quantity|default:5}{else}{$columns}{/if}{if $products_scroller} ut2-scroll-item{/if}"{if !$products_scroller && $smarty.foreach.sprod.first && $smarty.foreach.sproducts.first} data-ut2-grid="first-item"{/if}{if $ut2_load_more && $smarty.foreach.sprod.first && $smarty.foreach.sproducts.first} data-ut2-load-more="first-item"{/if}>
                        {include file="design/themes/responsive/templates/addons/variations_showcase/components/product_comp.tpl" template="grid"}

                    </div>
                {/foreach}

                {if $show_empty && $smarty.foreach.sprod.last}
                    {assign var="iteration" value=$smarty.foreach.sprod.iteration}

                    {capture name="iteration"}{$iteration}{/capture}
                    {hook name="products:$tmpl_extra"}
                    {/hook}
                    {assign var="iteration" value=$smarty.capture.iteration}
                    {if $iteration % $columns != 0}
                        {math assign="empty_count" equation="c - it%c" it=$iteration c=$columns}
                        {section loop=$empty_count name="empty_rows"}
                            <div class="ty-column{$columns}">
                                <div class="ut2-gl__item ut2-product-empty" style="aspect-ratio: var(--gl-item-width) / var(--gl-item-height)">
                                    <div class="ut2-gl__body">
                                        <span class="ty-product-empty__text">{__("empty")}</span>
                                        <div class="ut2-gl__image" style="min-height: {$tbh}px;"></div>
                                        <div class="ut2-gl__content" style="min-height:{$smarty.capture.abt__ut2_gl_content_height nofilter}px;"></div>
                                    </div>
                                </div>
                            </div>
                        {/section}
                    {/if}
                {/if}
            {/foreach}

            {if $ut2_load_more}
            {include file="common/abt__ut2_pagination.tpl" type="`$runtime.controller`_`$runtime.mode`" position="bottom" object="products"}
            {else}
        </div>
        {/if}

        {if $ab__add_ajax_loading_button}

            {$page = $block.content.items.page|default:1}
            {$id = "ut2_load_more_block_`$block.block_id`_`$block.snapping_id`"}
            {$load_more_total = $ut2_total_products_block_{$block.block_id}}
            {if $block.content.items.limit && $block.content.items.limit < $load_more_total}
                {$load_more_total = $block.content.items.limit}
            {/if}

            {$products_left = $load_more_total - $page * $block.properties.number_of_columns}
            {hook name="products:ut2_load_more_block"}
            {if $products_left > 0}
                {if $products_left > $block.properties.number_of_columns && $block.properties.abt__ut2_loading_type == "onclick"}
                    {$show_more_num = $block.properties.number_of_columns}
                {else}
                    {$show_more_num = $products_left}
                {/if}

                {$show_more_button='abt__ut2.load_more.show_more.products'}

                {if $block.type != 'main'}
                    {$show_more_button='abt__ut2.load_more.show_more'}
                {/if}

                <div id="{$id}_{$page + 1}" {if $page > 1 && $block.properties.abt__ut2_loading_type == "onclick_and_scroll"}class="hidden"{/if}><span id="{$id}_button" class="ty-btn ty-btn__outline load-more-btn" data-ca-snapping="{$block.snapping_id}" data-ca-grid-id="{$block.grid_id}" data-ca-block-id="{$block.block_id}" data-ca-current-page="{$page}" data-ca-load-type="{$block.properties.abt__ut2_loading_type}" data-ca-request-params="{fn_encrypt_text(json_encode($smarty.request))}">{__($show_more_button, [$show_more_num])}</span><!--{$id_{$page + 1}}--></div>
            {/if}
            {/hook}
        {/if}

        {if $products_scroller}
            <button class="ut2-scroll-right"><span class="ty-icon ty-icon-right-open-thin"></span></button>
            {include file="common/simple_scroller_init.tpl" block_id=$id elements_to_scroll=$elements_to_scroll|default: 2}
        {/if}
    </div>

    {if !$no_pagination}
        {include file="common/pagination.tpl"}
    {/if}
    {/if}

    {capture name="mainbox_title"}{$title}{/capture}
    {/strip}
