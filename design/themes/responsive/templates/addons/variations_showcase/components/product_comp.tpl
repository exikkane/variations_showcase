{assign var=obj_id_add value=$obj_id_add|default:$product.product_id}
<div id="ajax_update_{$obj_id_add}">
    {if $product}
        {if $template == 'grid'}
            {include file="design/themes/responsive/templates/addons/variations_showcase/components/grid_template.tpl" product=$product obj_id_add=$obj_id_add}
        {elseif $template == 'scroller'}
            {include file="design/themes/responsive/templates/addons/variations_showcase/components/scroller_template.tpl" product=$product obj_id_add=$obj_id_add}
        {/if}
    {/if}
    <!--ajax_update_{$obj_id_add}--></div>
{if $product}
    {include file="addons/variations_showcase/components/pr_var.tpl" product=$product obj_id_add=$obj_id_add}
{/if}