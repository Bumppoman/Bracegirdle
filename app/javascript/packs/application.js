// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../images', true);
const imagePath = (name) => images(name, true);

import $ from 'jquery';
window.$ = $;
window.jQuery = jQuery;

import 'bootstrap/dist/js/bootstrap';
import 'select2/dist/js/select2.min';
import 'jquery-steps/build/jquery.steps.min';
import 'fullcalendar/dist/fullcalendar.min';
import 'jquery-timepicker/jquery.timepicker';

require('jquery-ui/ui/widgets/datepicker');
require('jquery-ui/ui/effect');
require('jquery-ui/ui/effects/effect-highlight');

// Add DataTables jQuery plugin
require('imports-loader?define=>false!datatables.net')(window, $);
require('imports-loader?define=>false!datatables.net-rowreorder')(window, $);
require('imports-loader?define=>false!datatables.net-responsive')(window, $);

// Load datatables styles
import 'datatables.net-dt/css/jquery.dataTables.min.css'
import 'datatables.net-rowreorder-dt/css/rowReorder.dataTables.min.css'

import '../src/javascript/multistep';

import '../src/javascript/applications';
import '../src/javascript/appointments';
import '../src/javascript/attachments';
import '../src/javascript/cemeteries';
import '../src/javascript/cemetery_inspections';
import '../src/javascript/complaints';
import '../src/javascript/confirmation_modal';
import '../src/javascript/dashboard';
import '../src/javascript/limit_cemeteries';
import '../src/javascript/matters';
import '../src/javascript/notices';
import '../src/javascript/restoration';
import '../src/javascript/rules';
import '../src/javascript/trustees';
import '../src/javascript/users';
import '../src/javascript/slim';

import './stylesheet.scss';
