<?php
$wgVirtualRestConfig['modules']['parsoid'] = array(
  'url' => 'http://<%= @mediawiki[:name] %>:8142'
);
$wgVirtualRestConfig['modules']['parsoid']['forwardCookies'] = true;

require_once "$IP/extensions/VisualEditor/VisualEditor.php";

// Enable by default for everybody
// $wgDefaultUserOptions['visualeditor-enable'] = 1;

// Don't allow users to disable it
// $wgHiddenPrefs[] = 'visualeditor-enable';
