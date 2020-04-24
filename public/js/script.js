( function(){

	"use strict";

	angular
		.module('BiomarkBooking',[
			'ui.router',
			'ngStorage',
		])
		.filter("trust", ['$sce', function($sce) {
            return function(htmlCode){
              return $sce.trustAsHtml(htmlCode);
            }
		}])
		
})();
( function(){

	"use strict";

	angular
		.module('BiomarkBooking')
		.config(['$stateProvider','$urlRouterProvider','$locationProvider', function ($stateProvider, $urlRouterProvider, $locationProvider) {
			
			var environment = "development";
			if(environment =='development'){
				$locationProvider.html5Mode(false).hashPrefix('');
			}else{
				$locationProvider.html5Mode(true);
			}

    		$urlRouterProvider.otherwise('/');

    		$stateProvider
    			.state("home",{
		            url:"/",
		            template:"<booking></booking>",
				})
				.state("home.booking-locations",{
		            url:"booking-locations",
		            template:"<booking-locations></booking-locations>",
				})
				.state("home.booking-calendar",{
		            url:"booking-calendar",
		            template:"<booking-calendar></booking-calendar>",
				})
				.state("home.booking-profile",{
		            url:"booking-profile",
		            template:"<booking-profile></booking-profile>",
				})
				.state("home.booking-review",{
		            url:"booking-review",
		            template:"<booking-review></booking-review>",
				})
				.state("home.booking-confirmation",{
		            url:"booking-confirmation",
		            template:"<booking-confirmation></booking-confirmation>",
				})
		}])

	
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("bookingAdmin",{
            templateUrl:"/admin/view.html"
        })
})();
( function(){

	"use strict";

	angular
		.module('BiomarkBooking')
		.config(['$stateProvider','$urlRouterProvider','$locationProvider', function ($stateProvider, $urlRouterProvider, $locationProvider) {
			
    		$stateProvider
    			.state("admin",{
		            url:"/admin",
		            template:"<booking-admin></booking-admin>",
				})
				.state("admin.dashboard",{
		            url:"/dashboard",
		            template:"<admin-dashboard></adamin-dashboard>",
				})
				.state("admin.dashboard.users",{
		            url:"/users",
		            template:"<dashboard-users></dashboard-users>",
				})
				.state("admin.dashboard.locations",{
		            url:"/locations",
		            template:"<dashboard-locations></dashboard-locations>",
				})
				.state("admin.dashboard.clinics",{
		            url:"/clinics",
		            template:"<dashboard-clinics></dashboard-clinics>",
				})
				.state("admin.dashboard.bookings",{
		            url:"/bookings",
		            template:"<dashboard-bookings></dashboard-bookings>",
				})
				
		}])

	
})();
( function(){

	"use strict";

	angular
		.module('BiomarkBooking')
		.directive('clickOutside', [
            '$document', '$parse', '$timeout',
            clickOutside
        ])
		function clickOutside($document, $parse, $timeout) {
        return {
            restrict: 'A',
            link: function($scope, elem, attr) {

                // postpone linking to next digest to allow for unique id generation
                $timeout(function() {
                    var classList = (attr.outsideIfNot !== undefined) ? attr.outsideIfNot.split(/[ ,]+/) : [],
                        fn;

                    function eventHandler(e) {
                        var i,
                            element,
                            r,
                            id,
                            classNames,
                            l;

                        // check if our element already hidden and abort if so
                        if (angular.element(elem).hasClass("ng-hide")) {
                            return;
                        }

                        // if there is no click target, no point going on
                        if (!e || !e.target) {
                            return;
                        }

                        // loop through the available elements, looking for classes in the class list that might match and so will eat
                        for (element = e.target; element; element = element.parentNode) {
                            // check if the element is the same element the directive is attached to and exit if so (props @CosticaPuntaru)
                            if (element === elem[0]) {
                                return;
                            }
                            
                            // now we have done the initial checks, start gathering id's and classes
                            id = element.id,
                            classNames = element.className,
                            l = classList.length;

                            // Unwrap SVGAnimatedString classes
                            if (classNames && classNames.baseVal !== undefined) {
                                classNames = classNames.baseVal;
                            }

                            // if there are no class names on the element clicked, skip the check
                            if (classNames || id) {

                                // loop through the elements id's and classnames looking for exceptions
                                for (i = 0; i < l; i++) {
                                    //prepare regex for class word matching
                                    r = new RegExp('\\b' + classList[i] + '\\b');

                                    // check for exact matches on id's or classes, but only if they exist in the first place
                                    if ((id !== undefined && id === classList[i]) || (classNames && r.test(classNames))) {
                                        // now let's exit out as it is an element that has been defined as being ignored for clicking outside
                                        return;
                                    }
                                }
                            }
                        }

                        // if we have got this far, then we are good to go with processing the command passed in via the click-outside attribute
                        $timeout(function() {
                            fn = $parse(attr['clickOutside']);
                            fn($scope, { event: e });
                        });
                    }

                    // if the devices has a touchscreen, listen for this event
                    if (_hasTouch()) {
                        $document.on('touchstart', eventHandler);
                    }

                    // still listen for the click event even if there is touch to cater for touchscreen laptops
                    $document.on('click', eventHandler);

                    // when the scope is destroyed, clean up the documents event handlers as we don't want it hanging around
                    $scope.$on('$destroy', function() {
                        if (_hasTouch()) {
                            $document.off('touchstart', eventHandler);
                        }

                        $document.off('click', eventHandler);
                    });

                    /**
                     * @description Private function to attempt to figure out if we are on a touch device
                     * @private
                     **/
                    function _hasTouch() {
                        // works on most browsers, IE10/11 and Surface
                        return 'ontouchstart' in window || navigator.maxTouchPoints;
                    };
                });
            }
        };
    }
})();
( function(){
	//OEP
	"use strict";

	angular
		.module("BiomarkBooking")
		.constant("BiomarkConfig",{
			host:"http://localhost:4000/",
			socket:"ws://localhost:4000/cable",
			assets:",",
			countries:[
				{ "id":1,"name": "Malaysia", "dial_code": "+60", "code": "MY" },
				{ "id":5,"name": "Indonesia", "dial_code": "+62", "code": "ID" },
				{ "id":2,"name": "Philippines", "dial_code": "+63", "code": "PH" },
				{ "id":3,"name": "Singapore", "dial_code": "+65", "code": "SG" },
				
			],
			// assets:"https://demo.biomarking.org/profile/"
			assets:"https://assets.biomarking.com/"
		})
})();

( function(){
	"use strict";


	angular
		.module("BiomarkBooking")
		.service("Http",Http);

		Http.$inject=["$http","$sessionStorage","$state","$q","$localStorage"];

		function Http( $http, $sessionStorage ,$state , $q, $localStorage){
			// var host = "http://localhost:4000/";
			var host = "/";
            this.set_token = function(token){
				$sessionStorage.access_token = token;
			}
			this.post = function(path,params){
				$http.defaults.headers.common['x-access-token'] = $sessionStorage.access_token  || 0;
				return $http.post(host+path+".json",params);
			}
			this.patch = function(path,params){
				$http.defaults.headers.common['x-access-token'] = $sessionStorage.access_token  || 0;
				return $http.patch(host+path+".json",params);
			}
			this.delete = function(path){
				$http.defaults.headers.common['x-access-token'] = $sessionStorage.access_token  || 0;
				return $http.delete(host+path+".json");
			}
			
			this.get = function(path){
				$http.defaults.headers.common['x-session-token'] = $sessionStorage.access_token  || 0;
				return $http.get(host+path+".json");
			}
			
		}

})();


( function(){

	"use strict";

	angular
		.module('BiomarkBooking')
        .directive('numbersOnly', 
        
        function(){
        return {
            require: 'ngModel',
            link: function (scope, element, attr, ngModelCtrl) {
                function fromUser(text) {
                    if (text) {
                        var transformedInput = text.replace(/[^0-9]/g, '');
                        if (transformedInput !== text) {
                            ngModelCtrl.$setViewValue(transformedInput);
                            ngModelCtrl.$render();
                        }
                        return transformedInput;
                    }
                    return undefined;
                }            
                ngModelCtrl.$parsers.push(fromUser);
            }
        };
    })
})();

(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .factory("bookingService",bookingService);

        bookingService.$inject = ["$localStorage"];

        function bookingService( $localStorage ){
            var f = {};
            f.data = {};
            f.clinics = [
                {
                    id:1,
                    name:"Clinic 1"
                },
                {
                    id:2,
                    name:"Clinic 2"
                },
                {
                    id:3,
                    name:"Clinic 3"
                },
            ];
            f.save =  function(){
                $localStorage.booking = f.data;
            }
            f.get_booking_data = function(){
                return $localStorage.booking || {};
            }
            return f;
        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("booking",{
            controller:"bookingController",
            templateUrl:"/booking/view.html"
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("bookingController",bookingController);

        bookingController.$inject = ["bookingService"];

        function bookingController( bookingService ){
            
            var vm = this;
            
        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("adminDashboard",{
            controller:"adminDashboardController",
            templateUrl:"/admin/dashboard/view.html"
        })
})();
(function(){
    "use strict";

    angular 
        .module("BiomarkBooking")
        .controller("adminDashboardController",adminDashboardController);

        adminDashboardController.$inject = ["Http","$state"];

        function adminDashboardController(Http, $state){
            var vm = this;

            function error(){
                $state.go("admin");
            }
            function success(res){
                //can contain admin information
            }
            vm.$onInit = function(){
                Http
                    .post("v1/user/authenticate")
                    .then(success, error);
            }

        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("adminLogin",{
            controller:"adminLoginController",
            templateUrl:"/admin/login/view.html"
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("adminLoginController",adminLoginController);

        adminLoginController.$inject = ["Http","$state"];

        function adminLoginController( Http, $state ){
            var vm = this;
            vm.state = false;
            function error(err){
                alert(err.data.message);
            }
            function success(res){
                console.log(res)
                Http.set_token(res.data.token);
                $state.go("admin.dashboard");
            }
            vm.credential = {
                username:"tearhear18",
                password:"123123123"
            }
            vm.signIn = function(credential){
                Http
                    .post("v1/user/sign_in",{credential:credential})
                    .then(success,error);
            }
            vm.$onInit = function(){
                Http
                    .post("v1/user/authenticate")
                    .then(function(){
                        $state.go("admin.dashboard")
                    },function(){
                        vm.state = true;
                    })
            }
        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("bookingConfirmation",{
            controller:"bookingConfirmationController",
            templateUrl:"/booking/booking-confirmation/view.html"
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("bookingConfirmationController",bookingConfirmationController);

        bookingConfirmationController.$inject = ["bookingService","$state","Http"];

        function bookingConfirmationController(bookingService , $state, Http){
            var vm = this;

            vm.loading = true;

            vm.$onInit = function(){
                vm.booking = bookingService.get_booking_data();
                Http
                    .post("v1/guest/booking",{booking:vm.booking})
                    .then(function(res){
                        vm.booking = res.data.data;
                        vm.loading = false
                    },function(err){
                        alert(err.data.message);
                        vm.loading = false
                        $state.go('home.booking-review', null, {notify: false}).then(function() {
                            $window.location.reload();
                        });
                    });
            }
            
        }
})();

(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("bookingLocations",{
            controller:"bookingLocationController",
            templateUrl:"/booking/booking-locations/view.html"
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("bookingLocationController", bookingLocationController);

        bookingLocationController.$inject = ["bookingService","$state","Http"];

        function bookingLocationController(bookingService, $state, Http){
            var vm = this;

            vm.$onInit = function(){
                Http
                    .get("v1/guest/location")
                    .then(function(res){
                        vm.locations = res.data;
                    });
            }
            vm.locationClicked = function( loc ){
                vm.booking = bookingService.get_booking_data();
                vm.booking.location = loc;
                bookingService.data = vm.booking;
                bookingService.save();
                $state.go("home.booking-calendar");
            }
        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("bookingCalendar",{
            controller:"bookingCalendarController",
            templateUrl:"/booking/booking-calendar/view.html"
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("bookingCalendarController",bookingCalendarController);

        bookingCalendarController.$inject = ["bookingService","$state","Http"];

        function bookingCalendarController( bookingService, $state, Http){
            var vm = this;
            vm.is_selected = false;
            vm.scheduleSelected = function(sched){
                vm.booking.schedule = sched;
                delete vm.booking.slot;
                Http
                    .get("v1/guest/location/"+vm.booking.location.id+"/find_schedules/"+vm.booking.schedule.id)
                    .then(function(res){
                        vm.location.active_slot = res.data.active_slot;
                    });
            }
            vm.slotSelected = function(slot){
                if(slot.status) vm.booking.slot = slot;
            }
            vm.continue = function(){
                if(vm.booking.slot){
                    bookingService.data = vm.booking;
                    bookingService.save();
                    $state.go("home.booking-profile");
                }else{
                    alert("Please select slot");
                }
            }
            vm.$onInit = function(){
                vm.booking = bookingService.get_booking_data();
                vm.locations = bookingService.locations;
                vm.booking.txn = new Date().valueOf();
                Http
                    .get("v1/guest/location/"+vm.booking.location.id+"/schedules")
                    .then(function(res){
                        vm.location = res.data;
                        //initialize selection
                        vm.booking.schedule = {id:vm.location.schedules[0].id, schedule_date:vm.location.schedules[0].schedule_date}
                    });
            }
            
            var id = 0;
        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("bookingProfile",{
            controller:"bookingProfileController",
            templateUrl:"/booking/booking-profile/view.html"
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("bookingProfileController",bookingProfileController);

        bookingProfileController.$inject = ["bookingService","$state","Http"];

        function bookingProfileController( bookingService , $state , Http){
            var vm = this;
            vm.data = {
				terms: false,
				marketing: false,
				country_id: 1,
			};
            vm.$onInit = function(){
                vm.clinics = bookingService.clinics;
                vm.booking = bookingService.get_booking_data();
                vm.today = new Date();
                vm.booking.patient.date_of_birth = {date: vm.today};
                vm.booking = bookingService.get_booking_data();
                Http
                    .get("v1/guest/location/"+vm.booking.location.id+"/clinics")
                    .then(function(res){
                        vm.clinics = res.data;
                    });
            }
            vm.continue = function(){
                
                // if(vm.validate(vm.booking.patient)){
                    bookingService.data = vm.booking;
                    bookingService.save();
                    $state.go("home.booking-review");
                // }else{
                    // console.log("empty field", vm.fields);
                // }               
            }
            vm.validate = function(booking_patient){
                vm.fields={
                    full_name: false,
                    id_number: false,
                    gender_id: false,
                    date_of_birth: false,
                    contact_number: false,
                    email_address: false,
                    q1: false,
                    q2: false,
                    clinic_id: false
                }
                if(booking_patient.full_name == "" || booking_patient.full_name  == undefined){
                    vm.fields.full_name = true;
                    return false;
                }else if(booking_patient.id_number == "" || booking_patient.id_number  == undefined){
                    vm.fields.id_number = true;
                    return false;
                }else if(booking_patient.gender_id == "" || booking_patient.gender_id  == undefined){
                    vm.fields.gender_id = true;
                    return false;
                }else if(booking_patient.date_of_birth == "" || booking_patient.date_of_birth == undefined){
                    vm.fields.date_of_birth = true;
                    return false;
                }else if(booking_patient.contact_number == "" || booking_patient.contact_number == undefined ){
                    vm.fields.contact_number = true
                    return false;
                }else if(booking_patient.email_address == "" || booking_patient.email_address == undefined){
                    vm.fields.email_address = true;
                    return false;
                }else if(booking_patient.q1 == "" || booking_patient.q1 == undefined){
                    vm.fields.q1 = true;
                    return false;
                }else if(booking_patient.q2 == "" || booking_patient.q2 == undefined){
                    vm.fields.q1 = true;
                    return false;
                }else if(booking_patient.clinic_id == "" || booking_patient.clinic_id == undefined){
                    vm.fields.clinic_id = true;
                    return false;
                }else{
                    return true;
                }
            }
        }


})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("bookingReview",{
            controller:"bookingReviewController",
            templateUrl:"/booking/booking-review/view.html"
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("bookingReviewController",bookingReviewController);

        bookingReviewController.$inject = ["bookingService","$state","Http"];

        function bookingReviewController(bookingService , $state, Http){
            var vm = this;

            vm.continue = function(){
                $state.go("home.booking-confirmation")
            }
            vm.$onInit = function(){
                vm.locations = bookingService.locations;
                vm.clinicks =bookingService.clinics;
                vm.booking = bookingService.get_booking_data();
            }
            
        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("collectionDateCalendar",{
            bindings:{
				payload:"="
			},
            controller:"collectionDateCalendarController",
            templateUrl:"/booking/collection-date-calendar/view.html"
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("collectionDateCalendarController",collectionDateCalendarController);

        collectionDateCalendarController.$inject = ["$state","$timeout","$scope"];

        function collectionDateCalendarController( $state, $timeout , $scope){
            
            var vm = this;
            var mCal = {};
            vm.merian_bool = true;
            vm.is_calendar_open = false;
            vm.valid_date_bool = true;
            function onDateClicked(){
                
                var _date = new Date(mCal.interval[0].dataset.timestamp * 1000);
                var month = _date.getMinutes();
                var day = _date.getDate();
                var year = _date.getFullYear();
                vm.payload.date.setMonth(month+1);
                vm.payload.date.setYear(year);
                vm.payload.date.setDate(day);
                $scope.$apply();
                vm.check_date();
            }
            function set_new_clock(dt, h) {
                var s = /(\d+):(\d+)(.+)/.exec(h);
                dt.setHours(s[3] === "pm" ? 
                  12 + parseInt(s[1], 10) : 
                  parseInt(s[1], 10));
                dt.setMinutes(parseInt(s[2],10));
            }
            vm.set_meridian = function(meridian){
                vm._time.meridian = meridian;
                var vh = vm._time.hour+":"+vm._time.minute+vm._time.meridian.toLowerCase();
                set_new_clock(vm.payload.date,vh);
                vm.check_date();
            }

            vm.add_hour = function(){
                if(vm._time.hour < 12){
                    vm._time.hour+=1;
                    vm.payload.date.setHours(vm._time.hour);
                    vm.check_date();
                }
            }
            vm.sub_hour = function(){
                var selectedDay = vm.payload.date.getDate();
                var d = new Date();
                var currentHour = d.getHours();
                var currentDay = d.getDate();
                if(selectedDay == currentDay){
                    if(vm._time.hour > currentHour){
                        vm._time.hour-=1;
                        vm.payload.date.setHours(vm._time.hour);
                        vm.check_date();
                    }
                }else{
                    if(vm._time.hour > 1){
                        vm._time.hour-=1;
                        vm.payload.date.setHours(vm._time.hour);
                        vm.check_date();
                    }
                }
            }
            vm.add_minute = function(){
                var intMinute = parseInt(vm._time.minute);
                vm._time.minute = intMinute;
                if(vm._time.minute < 59){
                    vm._time.minute+=1;
                    vm.payload.date.setMinutes(vm._time.minute);
                }
                vm.check_date();
            }
            vm.sub_minute = function(){
                var selectedDay = vm.payload.date.getDate();
                var selectedHour = vm.payload.date.getHours();
                var d = new Date();
                var currentHour = d.getHours();
                var currentMin = d.getMinutes();
                var currentDay = d.getDate();
                if(selectedDay == currentDay && selectedHour == currentHour ){
                    if(vm._time.minute > currentMin){
                        vm._time.minute-=1;
                        vm.payload.date.setMinutes(vm._time.minute);
                    }
                }else{
                    if(vm._time.minute > 0){
                        vm._time.minute-=1;
                        vm.payload.date.setMinutes(vm._time.minute);
                    }
                }
            }
            vm.minute_data_change = function(){
                vm.payload.date.setMinutes(vm._time.minute);
                vm.check_date();
            }
            vm.hour_data_change = function(){
                vm.payload.date.setHours(vm._time.hour);
                vm.check_date();
            }
            vm.check_date = function () {
                vm.valid_date_bool = true;
                var selectedDay = vm.payload.date.getDate();
                var selectedMeridian = vm._time.meridian;
                
                var d = new Date();
                var currentDay = d.getDate();
                var currentHour = (d.getHours() + 11) % 12 + 1;
                var currentMinute = d.getMinutes();
                var currentMeridian = (d.getHours() < 12) ? "AM" : "PM";

                if (selectedDay == currentDay && vm._time.hour < currentHour && currentMeridian == selectedMeridian) {
                    vm.payload.date = d;
                    vm.valid_date_bool = false;
                } else if (selectedDay == currentDay && vm._time.hour == currentHour && vm._time.minute < currentMinute && currentMeridian == selectedMeridian) {
                    vm.payload.date = d;
                    vm.valid_date_bool = false;
                }

                if(vm._time.hour == '' || vm._time.minute == '' ||
                vm._time.hour == undefined || vm._time.minute == undefined){
                    vm.payload.date = d;
                    vm.valid_date_bool = false;
                }

                if(selectedDay == currentDay && currentMeridian == 'PM' && currentMeridian != selectedMeridian){
                    vm.valid_date_bool = false;
                }
        }
            vm.open_calendar = function(){
                vm.is_calendar_open = true;
                vm.$onInit();
            }
            vm.close_calendar = function(){
                if(!vm.valid_date_bool){
                    vm.is_calendar_open = true;
                }else{
                    vm.is_calendar_open = false;
                }
                
            }
            function clearCalendar() {
                vm.month.textContent = '';
            }
            
            function prevMonth(){
                clearCalendar();
                var prevMonth = vm.date.getMonth() - 1;
                vm.date.setMonth(prevMonth);
                updated();
        
            }
            function nextMonth(){
                
                clearCalendar();
                var nextMonth = vm.date.getMonth() + 1;
                vm.date.setMonth(nextMonth);
                updated();
            }
            vm.$onInit = function(){
                
                
                if(mCal.interval.length == 0){
                    
                    vm.payload.date = new Date();
                    vm._time = {
                        hour:  ((vm.payload.date.getHours() + 11) % 12 + 1), //( vm.payload.date.getHours() > 11 ) ? vm.payload.date.getHours()  - 12 : vm.payload.date.getHours(),
                        minute: vm.payload.date.getMinutes(),
                        meridian:  (vm.payload.date.getHours() < 12) ? "AM" : "PM"
                    }
                    var cc_date = angular.copy(vm.payload.date);
                    var timestamp = cc_date.setHours(0,0,0,0) / 1000;
                    mCal.interval.push({dataset:{timestamp:timestamp}});
                }
                //construct the calendar
                if(vm.is_calendar_open){
                    
                    $timeout(function(){
                        vm.selector = document.querySelector("#collection-date-calendar");
                        vm.header = creatHTMLElement(mCal.CSS_CLASSES.HEADER, vm.selector);
                        if (mCal.options.nav) {
                            vm.buttonPrev = creatHTMLElement(mCal.CSS_CLASSES.PREV, vm.header, mCal.options.nav[0]);
                            vm.label = creatHTMLElement(mCal.CSS_CLASSES.LABEL, vm.header);
                            vm.buttonNext = creatHTMLElement(mCal.CSS_CLASSES.NEXT, vm.header, mCal.options.nav[1]);
                            vm.buttonPrev.addEventListener('click', prevMonth);
                            vm.buttonNext.addEventListener('click', nextMonth);
                        } else {
                            vm.label = creatHTMLElement(mCal.CSS_CLASSES.LABEL, vm.header);
                        }
                        vm.week = creatHTMLElement(mCal.CSS_CLASSES.WEEK, vm.selector);
                        vm.month = creatHTMLElement(mCal.CSS_CLASSES.MONTH, vm.selector);

                        if (mCal.options.defaultDate) {
                            vm.date = new Date(mCal.options.defaultDate);
                            vm.currentDay = new Date(mCal.options.defaultDate);
                        } else {
                            vm.date = new Date();
                            vm.currentDay = new Date();
                        }
                        init();
                    });
                }
                
                if(vm._time.hour == '' || vm._time.minute == ''){
                    vm.payload.date = new Date();
                    vm._time.hour = (vm.payload.date.getHours() + 11) % 12 + 1;
                    vm._time.minute = vm.payload.date.getMinutes();
                }
            }
            function init() {

                if (mCal.options.defaultDate) {
                    vm.defaultDate = new Date(mCal.options.defaultDate);
                    vm.defaultDate.setDate(vm.defaultDate.getDate() + 1);
                }
        
                if (mCal.options.minDate) {
                    vm.minDate = new Date(mCal.options.minDate);
                    vm.minDate.setHours(0,0,0,0);
                }
        
                if (mCal.options.maxDate) {
                    mCal.options.maxDate = new Date();
                    mCal.options.maxDate.setDate(new Date().getDate());
                }
        
                vm.date.setDate(1);
                updated();
                //this.options.onLoad.call(this);
                // if (callback) {
                //     callback.call(this);
                // }
            }
            function updated(){
                var listDays = [];
                if (vm.label) {
                    vm.label.innerHTML = monthsAsString(vm.date.getMonth()) + ' ' + vm.date.getFullYear();
                }
                /** Define week format */
                vm.week.textContent = '';
                for (var i = mCal.options.weekStart; i < mCal.langs.daysShort.length; i++) {
                    listDays.push(i);
                }
        
                for (var i = 0; i < mCal.options.weekStart; i++) {
                    listDays.push(i);
                }
                
                for(var a = 0;a < listDays.length;a++){
                    createWeek(weekAsString(listDays[a]));
                }
                // for (var day of listDays) {
                //     createWeek(weekAsString(day));
                // }
        
                createMonth();
            }
            function weekAsString(weekIndex){
                return mCal.options.weekShort ? mCal.langs.daysShort[weekIndex] : mCal.langs.days[weekIndex];
            }
            function createWeek(dayShort){
                var weekDay = document.createElement('span');
                weekDay.classList.add(mCal.CSS_CLASSES.WEEK_DAY);
                weekDay.textContent = dayShort;
                vm.week.appendChild(weekDay);
            }
            function createMonth(){
                var currentMonth = vm.date.getMonth();
                while (vm.date.getMonth() === currentMonth) {
                    createDay(vm.date.getDate(), vm.date.getDay());
                    // jump while
                    vm.date.setDate(vm.date.getDate() + 1);
                }
        
                // put correct month
                vm.date.setMonth(vm.date.getMonth() - 1);
                selectDay( onDateClicked );
            }
            function selectDay(callback){
                
                vm.activeDates = vm.selector.querySelectorAll('.' + mCal.CSS_CLASSES.IS_ACTIVE);

                for(var i = 0; i < vm.activeDates.length;i++){
                    
                // for (var i of Object.keys(vm.activeDates)) {
                    if (mCal.interval[0]) {
                        if(mCal.interval[0].dataset.timestamp == vm.activeDates[i].dataset.timestamp){
                            vm.activeDates[i].classList.add(mCal.CSS_CLASSES.IS_SELECTED_START);
                        }                        
                        if (mCal.interval.length > 1) {
                            if(mCal.interval[1].dataset.timestamp == vm.activeDates[i].dataset.timestamp){
                                vm.activeDates[i].classList.add(mCal.CSS_CLASSES.IS_SELECTED_END);
                            }
                            if(vm.activeDates[i].dataset.timestamp > mCal.interval[0].dataset.timestamp && vm.activeDates[i].dataset.timestamp < mCal.interval[1].dataset.timestamp){
                                vm.activeDates[i].classList.add(mCal.CSS_CLASSES.IS_SELECTED_MEMBER);
                            }
                        }
                        
                    }
                    vm.activeDates[i].addEventListener('click',function(event){
                        var selectDay = event.target;
                        
                        if (selectDay.classList.contains(mCal.CSS_CLASSES.IS_DISABLED)) {
                            return;
                        }
        
                        mCal.lastSelectedDay = mCal.options.format ?
                            vm.formatDate(parseInt(selectDay.dataset.timestamp) * 1000, mCal.options.format) :
                            selectDay.dataset.timestamp;
        
                       
        
                        if (!selectDay.classList.contains(mCal.CSS_CLASSES.IS_DISABLED)) {
                            selectDay.classList.toggle(mCal.CSS_CLASSES.IS_SELECTED_START);
                        }
        
                        mCal.interval.length = 0;
                        mCal.selectedDays = [];
                        mCal.selectedTemporary = [];
                        mCal.interval.push(selectDay);
                        removeActiveClass();
                        selectDay.classList.add(mCal.CSS_CLASSES.IS_SELECTED_START);
        
                        // mCal.options.onSelect.call(this);
                        if (callback) {
                            callback.call(this);
                        }
                    });
                }
            }
            function removeActiveClass(){
                for(var i = 0; i < vm.activeDates.length;i++){
                // for (var i of Object.keys(vm.activeDates)) {
                    vm.activeDates[i].classList.remove(mCal.CSS_CLASSES.IS_SELECTED_START);
                    vm.activeDates[i].classList.remove(mCal.CSS_CLASSES.IS_SELECTED_END);
                    vm.activeDates[i].classList.remove(mCal.CSS_CLASSES.IS_SELECTED_MEMBER);
                }
            }
            function createDay (num, day){
                var unixTimestamp = new Date(vm.date).setHours(0,0,0,0);
                var timestamp = unixTimestamp / 1000;
                var newDay = document.createElement('div');
        
                newDay.textContent = num;
                newDay.classList.add(mCal.CSS_CLASSES.DAY);
                newDay.setAttribute('data-timestamp', timestamp);
        
                if (num === 1) {
                    if (mCal.options.weekStart === mCal.DAYS_WEEK.SUNDAY) {
                        newDay.style.marginLeft = ((day) * (100 / 7)) + '%';
                    } else {
                        if (day === mCal.DAYS_WEEK.SUNDAY) {
                            newDay.style.marginLeft = ((7 - mCal.options.weekStart) * (100 / 7)) + '%';
                        } else {
                            newDay.style.marginLeft = ((day - 1) * (100 / 7)) + '%';
                        }
                    }
                }
        
                if (day === mCal.DAYS_WEEK.SUNDAY || day === mCal.DAYS_WEEK.SATURDAY) {
                    newDay.classList.add(mCal.CSS_CLASSES.IS_WEEKEND);
                }
        
                if (mCal.options.disabledDaysOfWeek) {
                    if (mCal.options.disabledDaysOfWeek.includes(day)) {
                        newDay.classList.add(mCal.CSS_CLASSES.IS_DISABLED);
                    }
                }
        
                if (vm.date.getDate() > vm.currentDay.getDate()) {
                    newDay.classList.add(mCal.CSS_CLASSES.IS_DISABLED);
                } else {
                    newDay.classList.add(mCal.CSS_CLASSES.IS_ACTIVE);
                }
    
                if(vm.date.getMonth() > vm.currentDay.getMonth()){
                    newDay.classList.add(mCal.CSS_CLASSES.IS_DISABLED);
                }

                if (mCal.options.minDate && (vm.minDate.getTime() >= unixTimestamp)) {
                    newDay.classList.add(mCal.CSS_CLASSES.IS_DISABLED);
                } else {
                    newDay.classList.add(mCal.CSS_CLASSES.IS_ACTIVE);
                }
        
                if (mCal.options.maxDate && (mCal.options.maxDate.getTime() <= unixTimestamp)) {
                    newDay.classList.add(mCal.CSS_CLASSES.IS_DISABLED);
                } else {
                    newDay.classList.add(mCal.CSS_CLASSES.IS_ACTIVE);
                }
        
                if (mCal.options.disableDates) {
                    vm.setDaysDisable(unixTimestamp, newDay);
                }
        
                // Check if defaultDate exists so we set that defaultDate marked with the same style as Today
                if (vm.defaultDate) {
                    if (vm.defaultDate.setHours(0,0,0,0) === new Date(unixTimestamp).setHours(0,0,0,0)) {
                      newDay.classList.add(mCal.CSS_CLASSES.IS_TODAY);
                    }
                } else if (new Date(vm.date).setHours(0,0,0,0) === new Date(vm.currentDay).setHours(0,0,0,0) && mCal.options.todayHighlight) {
                    newDay.classList.add(mCal.CSS_CLASSES.IS_TODAY);
                }
        
                if (mCal.options.format) {
                    vm.selectedDays.find(function(day){
                        if (day === vm.formatDate(unixTimestamp, mCal.options.format)) {
                            newDay.classList.toggle(mCal.CSS_CLASSES.IS_SELECTED);
                        }
                    });
                } else {
                    mCal.selectedDays.find(function(day){
                        if (day === timestamp) {
                            newDay.classList.toggle(mCal.CSS_CLASSES.IS_SELECTED);
                        }
                    });
                }
        
                if (mCal.options.daysHighlight) {
                    vm.setDaysHighlight(unixTimestamp, newDay);
                }
        
                if (vm.month) {
                    vm.month.appendChild(newDay);
                }
        
                if (mCal.selectedTemporary.length > 0 && num === 1) {
                    mCal.interval[0] = newDay;
                }
            }
            function monthsAsString(monthIndex){
                return mCal.options.monthShort ? mCal.langs.monthsShort[monthIndex] : mCal.langs.months[monthIndex];
            }
            function creatHTMLElement(className, parentElement, textNode) {
                var elem = vm.selector.querySelector('.' + className);
                if (!elem) {
                    elem = document.createElement('div');
                    elem.classList.add(className);
                    if (textNode !== undefined) {
                        var text = document.createTextNode(textNode);
                        elem.appendChild(text);
                    }
                    parentElement.appendChild(elem);
                }
                return elem;
            }
            mCal.CSS_CLASSES = {
                MONTH        : 'biomark-calendar-v2__month',
                DAY          : 'biomark-calendar-v2__day',
                WEEK         : 'biomark-calendar-v2__week',
                WEEK_DAY     : 'biomark-calendar-v2__week__day',
                HEADER        : 'biomark-calendar-v2__header',
                LABEL        : 'biomark-calendar-v2__label',
                PREV        : 'biomark-calendar-v2__prev',
                NEXT        : 'biomark-calendar-v2__next',
                IS_ACTIVE    : 'is-active',
                IS_HIGHLIGHT : 'is-highlight',
                IS_SELECTED_START  : 'is-selected_start',
                IS_SELECTED_END  : 'is-selected_end',
                IS_SELECTED_MEMBER: "is-selected-member",
                IS_DISABLED  : 'is-disabled',
                IS_TODAY     : 'is-today',
                IS_WEEKEND   : 'is-weekend',
            };
            mCal.DAYS_WEEK= {
                SUNDAY    : 0,
                MONDAY    : 1,
                TUESDAY   : 2,
                WEDNESDAY : 3,
                THURSDAY  : 4,
                FRIDAY    : 5,
                SATURDAY  : 6,
            };
            mCal.selectedDays = [];
            mCal.lastSelectedDay = [];
            mCal.selectedTemporary = [];
            mCal.interval = [];
            mCal.selectedMonth;

            mCal.options = {
                nav: ['<', '>'],
                format: false,
                defaultDate: false,
                disablePastDays: true,
                weekStart: 0,
                range: false,
                minDate: true,
                maxDate: false,
                weekShort: true,
                onLoad : function(){
                    console.log("LOADED..");
                }
            };
            mCal.langs = {
                "days": [
                    "Sunday",
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday"
                ],
                "daysShort": [
                    "S",
                    "M",
                    "T",
                    "W",
                    "T",
                    "F",
                    "S"
                ],
                "daysMin": [
                    "Su",
                    "Mo",
                    "Tu",
                    "We",
                    "Th",
                    "Fr",
                    "Sa"
                ],
                "months": [
                    "January",
                    "February",
                    "March",
                    "April",
                    "May",
                    "June",
                    "July",
                    "August",
                    "September",
                    "October",
                    "November",
                    "December"
                ],
                "monthsShort": [
                    "Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "May",
                    "Jun",
                    "Jul",
                    "Aug",
                    "Sep",
                    "Oct",
                    "Nov",
                    "Dec"
                ],
                "today": "Today",
                "clear": "Clear"
            }

            
        }
})();
( function(){

	"use strict";

	angular
		.module("BiomarkBooking")
		.component('biomarkMobile',{
			bindings:{
				country:"=",
				mobile:"=",
				invalid:"=",
				submitted:"="
			},
			controller:"mobileController",
			templateUrl:"/booking/mobile/view.html"
		})
})();
( function(){
	
	"use strict";


	angular
		.module("BiomarkBooking")
		.controller("mobileController",mobileController);

		mobileController.$inject=["BiomarkConfig"];

		function mobileController( BiomarkConfig ){
			var vm = this;

			vm.$onInit = function(){
				vm.is_visible = false;
				var opt = vm.country || 0;
				vm.countries = BiomarkConfig.countries;	
				vm.default  = BiomarkConfig.countries[opt-1];
				// vm.mobile_placeholder = "2 1234 5678";
				// vm.mobile_regex = "^[0-9]{1,9}$";
				// vm.mobile_max = 9;
				vm.select_dialcode = function(){
					vm.is_visible = !vm.is_visible;
				}
				vm.onValueChanged = function( data ){
					vm.default = data;
					vm.country = data.id;
					switch(data.code){
						case "PH":
							vm.mobile_placeholder = "915 123 4567";
							vm.mobile_regex = "^9[0-9]{1,9}$";
							vm.mobile_min = 10;
							vm.mobile_max = 10;
						break;
						case "SG":
							vm.mobile_placeholder = "1234 4567";
							vm.mobile_regex = "^[0-9]{1,8}$";
							vm.mobile_min = 8;
							vm.mobile_max = 8;

						break;
						case "MY":
							vm.mobile_placeholder = "12 1234 5678";
							vm.mobile_regex = "(^[0-9]{1,9})|(^[0-9]{1,10})";
							vm.mobile_min = 8;
							vm.mobile_max = 10;
						break;
						case "ID":
							vm.mobile_placeholder = "12 1234 5678";
							vm.mobile_regex = "(^[0-9]{1,9})|(^[0-9]{1,10})";
							vm.mobile_min = 8;
							vm.mobile_max = 12;
						break;
					}
				}

				switch(vm.default.code){
					case "PH":
						vm.mobile_placeholder = "915 123 4567";
						vm.mobile_regex = "^9[0-9]{1,9}$";
						vm.mobile_min = 10;
						vm.mobile_max = 10;
					break;
					case "SG":
						vm.mobile_placeholder = "1234 4567";
						vm.mobile_regex = "^[0-9]{1,8}$";
						vm.mobile_min = 8;
						vm.mobile_max = 8;

					break;
					case "MY":
						vm.mobile_placeholder = "12 1234 5678";
						vm.mobile_regex = "(^[0-9]{1,9})|(^[0-9]{1,10})";
						vm.mobile_min = 8;
						vm.mobile_max = 10;
					break;
					case "ID":
						vm.mobile_placeholder = "12 1234 5678";
						vm.mobile_regex = "(^[0-9]{1,9})|(^[0-9]{1,10})";
						vm.mobile_min = 8;
						vm.mobile_max = 12;
					break;
				}
				

			}
		}

})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("dashboardBookings",{
            controller:"dashboardBookingsController",
            templateUrl:"/admin/dashboard/bookings/view.html"
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("dashboardBookingsController",dashboardBookingsController);

        dashboardBookingsController.$inject = ["Http"];

        function dashboardBookingsController( Http ){
            var vm = this;


            vm.$onInit = function(){
                Http    
                    .get("v1/booking")
                    .then(function(res){
                        vm.bookings = res.data;
                        console.log(res)
                    });
            }
            
        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("dashboardClinics",{
            controller:"dashboardClinicController",
            templateUrl:"/admin/dashboard/clinics/view.html"
        })
})();
(function () {
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("dashboardClinicController", dashboardClinicController);

    dashboardClinicController.$inject = ["Http"];

    function dashboardClinicController(Http) {
        var vm = this;
        vm.clinic_modal = false;

        vm.cancel = function () {
            vm.clinic_modal = false;
        }
        vm.openModal = function () {
            vm.clinic_modal = true;
        }
        vm.addClinic = function (data, mode) {
            if (mode == "add") {
                Http
                    .post("v1/clinic", { clinic: data })
                    .then(function (res) {
                        vm.clinics.push(res.data.data);
                        vm.clinic = {};
                        vm.clinic_modal = false;
                    });
                //add clinic
            } else {
                //update clinic
            }
        }
        vm.$onInit = function () {
            Http
                .get("v1/clinic")
                .then(function (res) {
                    vm.clinics = res.data;
                })
        }
    }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("dashboardSidemenu",{
            // controller:"adminDashboardController",
            templateUrl:"/admin/dashboard/sidemenu/view.html"
        })
})();

(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("dashboardUsers",{
            controller:"dashboardUsersController",
            templateUrl:"/admin/dashboard/users/view.html"
        })
})();
(function(){
    "use strict";

    angular 
        .module("BiomarkBooking")
        .controller("dashboardUsersController",dashboardUsersController);

        dashboardUsersController.$inject = ["Http","$state"];

        function dashboardUsersController(Http, $state){
            var vm = this;
        

        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("dashboardLocations",{
            controller:"dashboardLocationsController",
            templateUrl:"/admin/dashboard/locations/view.html"
        })
})();
(function(){
    "use strict";

    angular 
        .module("BiomarkBooking")
        .controller("dashboardLocationsController",dashboardLocationsController);

        dashboardLocationsController.$inject = ["Http"];

        function dashboardLocationsController(Http){
            var vm = this;

            vm.location_modal = false; //set to initial state
            var location_index;
            vm.location = {};
            vm.cancel = function(){
                vm.location_modal = false;
            }
            vm.delete = function(data , index ){
                Http.delete("v1/location/"+data.id)
                .then(function(res){
                    vm.locations.splice( index , 1);
                });
            }
            vm.save_or_update = function(data){
                if(vm.mode == "add"){
                    Http
                        .post("v1/location",{location:data})
                        .then(function(res){
                            vm.locations.push(res.data.data);
                            vm.location = {};
                            vm.location_modal = false;
                        })
                }else{
                    Http
                        .patch("v1/location/"+data.id,{location:data})
                        .then(function(res){
                            vm.locations[location_index] = data;
                            vm.location = {};
                            vm.location_modal = false;
                        });
                }
            }
            vm.openModal = function( mode, data , index ){
                if(mode =='edit'){
                    location_index = index;
                    vm.location = angular.copy(data);
                }
                vm.mode = mode;
                vm.location_modal = true;
            }
            vm.$onInit = function(){
                Http
                    .get("v1/location")
                    .then(function(res){
                        vm.locations = res.data;
                    })
            }
        }
})();
( function(){

	"use strict";

	angular
		.module('BiomarkBooking')
		.config(['$stateProvider','$urlRouterProvider','$locationProvider', function ($stateProvider, $urlRouterProvider, $locationProvider) {
			
    		$stateProvider
    			.state("admin.dashboard.locations.view",{
		            url:"/view/:id",
		            template:"<location-view></location-view>",
				})
				
		}])

	
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("locationClinics",{
            controller:"locationClinicsController",
            templateUrl:"/admin/dashboard/locations/clinics/view.html"
        })
})();
(function () {
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("locationClinicsController", locationClinicsController);

    locationClinicsController.$inject = ["Http", "$state"];

    function locationClinicsController(Http, $state) {
        var vm = this;
        vm.location_clinic_modal = false;
        vm.location_clinics = {}

        vm.$onInit = function () {
            Http
                .get("v1/location/" + $state.params.id + "/location_clinics")
                .then(function (res) {
                    vm.location_clinics = res.data;
                    console.log(vm.location_clinics)
                });
        }

        vm.open_clinic_modal = function () {
            vm.location_clinic_modal = true;
            Http
                .get("v1/clinic")
                .then(function (res) {
                    vm.clinic_list = res.data;
                });
        }
        vm.cancel = function () {
            vm.location_clinic_modal = false;
        }


        vm.save_location_clinic = function (clinic_id) {
            Http
                .post("v1/location/add_location_clinic", { location: { location_id: $state.params.id, clinic_id: clinic_id } })
                .then(
                    function (res) {
                        if (res.data.message == "success") {
                            vm.location_clinics.push(res.data.data)
                            vm.location_clinic_modal = false;
                            vm.clinic_id = 0
                        } else {
                            alert(res.data.message)
                        }

                    }, function (err) {
                        alert(err)
                    })

        }


    }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("locationSchedules",{
            controller:"locationSchedulesController",
            templateUrl:"/admin/dashboard/locations/schedules/view.html"
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("locationSchedulesController",locationSchedulesController);

        locationSchedulesController.$inject = ["Http","$state"];

        function locationSchedulesController(Http, $state){

            var vm = this;
            vm.schedule_modal = false;
            vm.openSchedule = function(a){
                a.close_schedule_modal = close_schedule_modal;
                vm.schedule_data = a;
                vm.schedule_modal = true;
            }
            function close_schedule_modal(){
                vm.schedule_modal = false;
            }
            vm.generator = {
                date_from:"2020-04-21",
                date_to:"2020-04-30",
                allocation_per_slot:1,
                minutes_interval:10,
                morning:{
                    start:7,
                    end:11
                },
                afternoon:{
                    start:1,
                    end:5
                }
            }
            vm.showGenerator = function(){
                vm.generator_modal = true;
            }
            vm.cancel = function(){
                vm.generator_modal = false;           
            }
            vm.generate = function(data){
                //inject location id
                data.location_id = $state.params.id;
                Http    
                    .post("v1/schedule",{schedule:data})
                    .then(function(res){
                        vm.generator_modal = false;
                        vm.generator = {};
                    });    
            }
            vm.$onInit = function(){
                Http
                    .get("v1/location/"+$state.params.id+"/schedules")
                    .then(function(res){
                        console.log(res.data);
                        vm.schedules = res.data;
                    });
            }
            
        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("locationUsers",{
            controller:"locationUsersController",
            templateUrl:"/admin/dashboard/locations/users/view.html"
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("locationUsersController",locationUsersController);

        locationUsersController.$inject = [];

        function locationUsersController(){
            var vm = this;
            
        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("locationView",{
            controller:"locationsController",
            templateUrl:"/admin/dashboard/locations/view/view.html"
        })
})();
(function(){
    "use strict";

    angular 
        .module("BiomarkBooking")
        .controller("locationsController",locationsController);

        locationsController.$inject = ["Http","$state"];

        function locationsController(Http, $state){
            var vm = this;
            
            vm.default_index = 2; //set initiali position to tab index 0
            vm.tabClicked = function(index){
                vm.default_index = index;
                console.log(index)
            }
            vm.tabs = [
                {
                    id:0,
                    name:"USERS"
                },
                {
                    id:1,
                    name:"CLINICS"
                },
                {
                    id:2,
                    name:"SCHEDULES"
                },
                {
                    id:3,
                    name:"PATIENT APPOINTMENTS"
                },
            ];
            vm.$onInit = function(){
                Http.get("v1/location/"+$state.params.id).then(function(res){
                    vm.location = res.data;
                });
            }
        }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("scheduleModal",{
            bindings:{
                payload:"="
            },
            controller:"scheduleModalController",
            templateUrl:"/admin/dashboard/locations/schedules/schedule-modal/view.html"
        })
})();
(function(){
    "use strict";

    angular 
        .module("BiomarkBooking")
        .controller("scheduleModalController",scheduleModalController);

        scheduleModalController.$inject = ["Http"];

        function scheduleModalController( Http ){
            var vm = this;
            vm.$onInit = function(){
                // console.log(vm.payload);
                Http
                    .get("v1/schedule/"+vm.payload.id)
                    .then(function(res){
                        vm.slots = res.data.active_slot.data;
                        console.log(vm.slots);
                    });
            }
        }
})();