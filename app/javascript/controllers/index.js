// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller.js"
application.register("hello", HelloController)

import Datatable from './datatable_controller'
application.register('datatable', Datatable)