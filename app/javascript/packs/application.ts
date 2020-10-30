// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../images', true);
const imagePath = (name) => images(name);

import 'choices.js/public/assets/scripts/choices.min';

import BSN from 'bootstrap.native/dist/bootstrap-native.esm.min.js';
(window as unknown as Window & typeof globalThis & { BSN: BSN }).BSN = BSN;

/*
 * Stimulus.js loader
 */
import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';

const application = Application.start();
const context = require.context('../src/javascript/controllers', true, /\.ts$/);
application.load(definitionsFromContext(context));

import '../src/javascript/dashboard';

import './stylesheet.scss';