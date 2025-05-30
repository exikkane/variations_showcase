<?php

if ($mode == 'change_variant') {
    if (defined('AJAX_REQUEST')) {
        $product_id = (int)$_REQUEST['variant_id'];

        [$products,] = fn_get_products(['pid' => $product_id, 'include_child_variations' => true]);
        fn_gather_additional_products_data($products, ['get_discounts' => true, 'get_variation_features_variants' => true, 'get_icon' => false, 'get_detailed' => true, 'get_options' => false]);

        Tygh::$app['view']->assign('product', $products[$product_id]);
        Tygh::$app['view']->assign('obj_id_add', (int) $_REQUEST['ob_id']);
        Tygh::$app['view']->assign('template', $_REQUEST['template']);

        Tygh::$app['view']->display('addons/variations_showcase/components/product_comp.tpl');
        exit;
    }
}