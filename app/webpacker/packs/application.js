/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
window.$ = $; // to get jQuery or some other library you're after, if you'd want it
window.jQuery = jQuery;

require("@rails/activestorage").start();
require("@rails/ujs").start();
require("turbolinks").start();
import 'bootstrap/dist/js/bootstrap';
import 'select2/dist/js/select2.min';
import 'jquery-steps/build/jquery.steps.min'

require('jquery-ui/ui/widgets/datepicker');
require('jquery-ui/ui/effect');
require('jquery-ui/ui/effects/effect-highlight')

require('datatables.net')(window, $);
require('datatables.net-responsive')(window, $);

import '../src/javascript/multistep';

import '../src/javascript/attachments';
import '../src/javascript/cemeteries';
import '../src/javascript/cemetery_inspections';
import '../src/javascript/complaints';
import '../src/javascript/confirmation_modal';
import '../src/javascript/dashboard';
import '../src/javascript/limit_cemeteries';
import '../src/javascript/notices';
import '../src/javascript/restoration';
import '../src/javascript/rules';
import '../src/javascript/trustees';
import '../src/javascript/slim';