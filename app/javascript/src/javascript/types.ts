import Choices from 'choices.js';

import ApplicationController from './controllers/application_controller';

export type BracegirdleSelect = HTMLSelectElement & { choicesInstance: Choices }
export type StimulusElement = HTMLElement & { stimulusController: ApplicationController }