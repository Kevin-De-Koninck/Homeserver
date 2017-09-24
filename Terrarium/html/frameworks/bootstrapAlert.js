/*!
 * BootstrapAlert v1.0
 * Copyright MantaCode Sp. z o.o.
 * Licensed under MIT
 * requires: jQuery, Bootstrap
 */
(function (root, factory) {
    'use strict';
    if (typeof define === "function" && define.amd) {
         define("bootstrapAlert", [ "jquery" ], function(a0) {
             return root["BootstrapAlert"] = factory(a0);
         });
    } else if (typeof exports === "object") {
         module.exports = factory(require("jquery"));
    } else {
         root["BootstrapAlert"] = factory(jQuery);
    }
 })(this, function($) {
     'use strict';

     function createBootstrapAlert() {
         var BootstrapAlert = {};

         function showAlert(cssClass, userConfig) {
             var config = {
                 autoHide: true,
                 hideTimeout: 3000,
                 dissmissible: false,
                 parentClass: 'bootstrap-alert',
                 innerClass: 'bootstrap-alert-message',
                 title: '',
                 message: ''
             };
             $.extend(config, userConfig);

             var contentStyle = [
                 'position: relative;',
                 'width: 100%;',
                 'left: -50%;'
             ].join('');

             var alertContent = document.createElement('div');
             alertContent.className = 'alert ' + config.innerClass + ' ' + cssClass;
             alertContent.setAttribute('role', 'alert');
             alertContent.style = contentStyle;
             if (config.dissmissible) {
                 alertContent.innerHTML += [
                     '<button type="button" class="close" data-dismiss="alert">',
                         '<span aria-hidden="true">&times;</span>',
                     '</button>'
                 ].join('');
             }
             alertContent.innerHTML += '<strong>' + config.title + '</strong> ' + config.message;


             var alertElement = document.createElement('div');
             alertElement.className = config.parentClass;
             alertElement.style = [
                 'position: fixed;',
                 'width: 90%;',
                 'max-width: 600px;',
                 'left: 50%;',
                 'top: 15px;',
                 'z-index: 9999;',
             ].join('');
             alertElement.appendChild(alertContent);
             document.body.appendChild(alertElement);

             if(config.autoHide) {
                 window.setTimeout(function() {
                     $(alertElement).fadeOut(function() {
                         $(alertElement).remove();
                     });
                 }, config.hideTimeout);
             }

             $(alertElement).on('closed.bs.alert', function () {
                 $(alertElement).remove();
             });
         }

         BootstrapAlert.alert = function (config) {
             showAlert('alert-danger', config);
         };

         BootstrapAlert.info = function (config) {
             showAlert('alert-info', config);
         };

         BootstrapAlert.warning = function (config) {
             showAlert('alert-warning', config);
         };

         BootstrapAlert.success = function (config) {
             showAlert('alert-success', config);
         };

         return BootstrapAlert;
     }
     return createBootstrapAlert();
 });
