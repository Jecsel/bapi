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
                        console.log(vm.location);
                    });
            }
            
            var id = 0;
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

        bookingProfileController.$inject = ["bookingService","$state"];

        function bookingProfileController( bookingService , $state ){
            var vm = this;

            vm.continue = function(){
                bookingService.data = vm.booking;
                bookingService.save();
                $state.go("home.booking-review");
            }
            vm.$onInit = function(){
                vm.clinics = bookingService.clinics;
                console.log(vm.clinics);
                vm.booking = bookingService.get_booking_data();
                console.log(vm.booking);
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