( function(){

	"use strict";

	angular
		.module('BiomarkBooking',[
			'ui.router',
			'ngStorage',
			'ngMaterial',
			'ngMaterialDatePicker',
			'ngCsv'
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
				.state("referrals",{
					url:"/referrals/:ref_code",
					template:"<booking></booking>",
					controller:["bookingService","$state",function(bookingService, $state){
						//declare setting of referrals
						var booking = bookingService.get_booking_data();
                		booking.referral_code = $state.params.ref_code;
                		bookingService.data = booking;
                		bookingService.save();
					}],
					params: {
						ref_code: { squash: true, value: null },
					}
				})
    			.state("home",{
		            url:"/",
					template:"<booking></booking>",
				})
				.state("home.booking-locations",{
		            url: "booking-locations",
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
				.state("admin.dashboard.settings",{
					url:"/settings",
					template:"<dashboard-settings></dashboard-settings>"
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
            f.clear = function(){
                $localStorage.booking = {};
            }
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

        bookingController.$inject = ["bookingService","$state"];

        function bookingController( bookingService, $state ){
            
            var vm = this;
            vm.frequent= [
                {
                    question:"How do we test for Covid-19?",
                    status_faq:false,
                    desc:"We use a technique called Reverse Transcription Polymerase Chain Reaction or RT-PCR. The Ministry of Health Malaysia has recommended to test patients who have symptoms of COVID-19 using this technique. It is currently the 'gold standard' for Covid-19 testing. This test looks at the specific genetic material of the COVID-19 virus to determine whether it is present or not."
                },
                {
                    question:"What does the test involve?",
                    status_faq:false,
                    desc:"<p>1. A swab will be taken from your nose and throat or you may be required to provide a sputum sample.</p> <p>2. Your samples will be analysed at our laboratory for the specific genes of the Covid-19 virus.</p> <p>3.Your test result will be ready in 24-48 hours.</br> <p>4.A doctor (which can be of your choosing) will review your result and advise you on next steps.</p><p>5.The testing process will take around 5 minutes.</p>"
                },
                {
                    question:"What are the qualifications of your laboratories?",
                    status_faq:false,
                    desc:"Your test will be performed at RT-PCR lab approved by the Ministry of Health at one of our labs. Each lab is MS ISO 15189 accredited, the gold standard for pathology laboratories around the world."
                },
                {
                    question:"Am I eligible to take the Covid-19 test?",
                    status_faq:false,
                    desc:"All individuals without symptoms who wishes to screen for COVID-19 are eligible. Individuals with symptoms, but no history of travelling overseas and no history of contact with known case of COVID-19 are eligible."
                },
                {
                    question:"Are walk-ins accepted?",
                    status_faq:false,
                    desc:"No. We provide Drive-Thru screening services by appointments only."
                },
                {
                    question:"I’ve booked my appointment but would like to change the time?",
                    status_faq:false,
                    desc:"Please contact our call centre at 1800 22 6843."
                },
                {
                    question:"What do I bring to the test?",
                    status_faq:false,
                    desc:"Please bring your IC card or passport  and your booking confirmation email."
                },
                {
                    question:"Where can I get a drive-through COVID-19  test near me?",
                    status_faq:false,
                    desc:"You can find the list of Covid-19 Drive through location <a href='https://my.biomarking.com'>here</a>."
                },
                {
                    question:"Do I need to make advance payment?",
                    status_faq:false,
                    desc:"Yes, advance payment is required prior to conducting the COVID-19 Drive-Thru Screening Services."
                },
                {
                    question:"What payment methods are accepted?",
                    status_faq:false,
                    desc:"We accept a variety of online payment methods via ipay88 (local internet banking and credit/debit cards). ipay88 is a regulated payment service provider under Malaysia Payment System Act offering local internet banking service."
                },
                {
                    question:"Can I claim my insurance?",
                    status_faq:false,
                    desc:"You are advised to check with your respective insurance providers for information on coverage and compensation."
                },
            ];
            // vm.$onInit = function(){
            //     vm.booking = bookingService.get_booking_data();
            //     vm.booking.referral_code = $state.params.ref_code;
            //     bookingService.data = vm.booking;
            //     bookingService.save();
            // }
            vm.show_faq = function(indx){         
                for(var i=0; i < vm.frequent.length; i++){
                     i == indx ? !vm.frequent[i].status_faq ? vm.frequent[i].status_faq = true : vm.frequent[i].status_faq = false : vm.frequent[i].status_faq = false;
                }
            }
            vm.scroll_to = function(){
                var elmnt = document.getElementById("frequent_id");
                elmnt.scrollIntoView();
            }
            
        }
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
        .component("adminDashboard",{
            controller:"adminDashboardController",
            templateUrl:"/admin/dashboard/view.html"
        })
})();
(function () {
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("adminDashboardController", adminDashboardController);

    adminDashboardController.$inject = ["Http", "$state","$sessionStorage"];

    function adminDashboardController(Http, $state, $sessionStorage) {
        var vm = this;
        vm.loading = true;

        function error(err) {
            alert("Invalid access")
            $state.go("admin");
        }
        function success(res) {
            //can contain admin information
            vm.loading = false
            if (res.data.message) {
                
                alert("User has no policies. Contact admin for details")
                $sessionStorage.access_token = 0;
                $state.go("admin");
                return false;
            }
            vm.services = res.data.policies;
        }
        vm.$onInit = function () {
            Http
                .post("v1/user/get_policies")
                .then(success, error);
        }
        vm.logout = function(){
            $sessionStorage.access_token = 0;
            $state.go("admin");
        }

    }
})();
( function(){
	"use strict";


	angular
		.module("BiomarkBooking")
		.factory("Dashboard", Dashboard);

		Dashboard.$inject=[];


		function Dashboard(){
                
            var f = {
                data:{
                    pagination: 1
                },
                init:init
            }

            function init(cb){
                cb(f.data)
            }

            return f;
		}

})();
(function(){

    angular
        .module("BiomarkBooking")
        .component("pagination", {
            bindings:{
				config:"=",
                paginate:"="
			},
            controller: "paginationController",
            templateUrl: "/admin/pagination/view.html"
        })
})();
(function(){
    angular
        .module("BiomarkBooking")
        .controller("paginationController", paginationController)

        paginationController.$inject = ["Dashboard"];

        function paginationController(Dashboard){
            var vm = this;
			// vm.records = dataJson.records;
            var local_configurations = {
                item_per_page: 10,
                padding_per_page: 4,
            };
            Dashboard.init(function(data){
                vm.portal = data;     
                // vm.patients = vm.data;
            });
            vm.$onInit = function () {
                vm.pagination = angular.merge(local_configurations, vm.config);
				vm.portal.pagination = 1;
				vm.pagination.page_position = 1;
                init();
            }
          
            vm.btn_previous = false;
            vm.btn_next = true;
            vm.btn_dotdot = true;
            vm.btn_last = true;
            vm.page_elements = [];

            function init(){
				
                var last_show_page = vm.pagination.page_position + vm.pagination.padding_per_page-1;
                
				vm.btn_dotdot = (last_show_page >= vm.pagination.total_pages) ? false : true;
				vm.btn_previous = (vm.pagination.page_position > 1 );
				vm.btn_next = (vm.pagination.page_position != vm.pagination.total_pages );

				if(last_show_page <= vm.pagination.total_pages){
					vm.page_elements.length = 0;
					if(vm.pagination.total_pages > vm.pagination.padding_per_page){
						for( var i = 1;i <= vm.pagination.total_pages; i++ ){
							if(i >= vm.pagination.page_position && i <= last_show_page){
								vm.page_elements.push(i);
							}
						}

					}else{
						for(var i = 1;i <= vm.pagination.total_pages; i++ ){
							vm.page_elements.push(i);
						}
					}
				}else{
					vm.page_elements.length = 0;
					var partial_index = vm.pagination.total_pages - vm.pagination.padding_per_page +1;
					for( var i = 1;i <= vm.pagination.total_pages; i++ ){
						if(i >= partial_index && i <= vm.pagination.total_pages){
							vm.page_elements.push(i);
						}
					}
				}
				
				
			}
			
			
			vm.previous = function(){
				vm.portal.pagination -=1;	
				vm.pagination.page_position -=1;
				vm.paginate( vm.portal.pagination );
				init();
			}
			vm.next = function(){
				vm.portal.pagination +=1;
				vm.pagination.page_position +=1;
				vm.paginate( vm.portal.pagination );
				init();
			}
			vm.page_click = function( page ){
				vm.portal.pagination = page;
				vm.pagination.page_position = page;
				vm.paginate( vm.portal.pagination );
				init();
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
                Http.set_token(res.data.token);
                $state.go("admin.dashboard");
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
            var has_allocation,counter;
            var vm = this;
            vm.is_selected = false;
            vm.scheduleSelected = function(sched){
                if(sched.id == vm.booking.schedule.id) return false;
                vm.booking.schedule = sched;
                delete vm.booking.slot;
                Http
                    .get("v1/guest/location/"+vm.booking.location.id+"/find_schedules/"+vm.booking.schedule.id)
                    .then(function(res){
                        vm.location.active_slot = res.data.active_slot;
                        vm.location.has_available_slot = res.data.has_available_slot;
                        slot_mapper();
                    });
            }
            vm.slotSelected = function(slot){
                if(slot.status) vm.booking.slot = slot;
            }
            vm.continue = function(){
                if(!vm.booking.slot){
                    alert("Please select slot");
                    return false;
                }
                vm.booking.booking_calendar_state = true;
                bookingService.data = vm.booking;
                bookingService.save();
                $state.go("home.booking-profile");
            }
            vm.$onInit = function(){
                vm.booking = bookingService.get_booking_data();
                if(!vm.booking.location_state || !vm.booking.location.id){
                    $state.go("home.booking-locations");
                    return false;
                }
                vm.locations = bookingService.locations;
                Http
                    .get("v1/guest/location/"+vm.booking.location.id+"/schedules")
                    .then(function(res){
                        vm.location = res.data;
                        vm.booking.schedule = {id:vm.location.schedules[0].id, schedule_date:vm.location.schedules[0].schedule_date}
                        slot_mapper();
                    });
            }
            function slot_mapper(){
                has_allocation = false;
                //try to auto select morning schedules
                auto_assign_slot("AM");
                //if morning is full try to allocate afternoon
                if(!has_allocation) auto_assign_slot("PM");
            }
            function auto_assign_slot(meridian){
                counter = 0;
                do{
                    if(vm.location.active_slot.data[meridian][counter].status){
                        vm.booking.slot = vm.location.active_slot.data[meridian][counter];
                        has_allocation = true;
                    };
                    counter++;
                }while(!has_allocation  && counter < vm.location.active_slot.data[meridian].length)
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
                console.log("DATA",vm.booking);
                Http
                    .post("v1/guest/booking",{booking:vm.booking})
                    .then(function(res){
                        bookingService.clear();
                        vm.booking = res.data.data;
                        vm.loading = false
                    },function(err){
                        alert(err.data.message);
                        vm.loading = false
                        $state.go('home.booking-review', null, {notify: false}).then(function() {
                            $window.location.reload();
                            // $window.location.replace = "";
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
                vm.booking.location_state = true;
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
                vm.booking = bookingService.get_booking_data();
                if(!vm.booking.profile_state){
                    $state.go("home.booking-profile");
                    return false;
                }
                if(!vm.booking.patient){
                    $state.go("home.booking-profile");
                    return false;
                }
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

        bookingProfileController.$inject = ["bookingService","$state","Http"];

        function bookingProfileController( bookingService , $state , Http){
            var vm = this;
            //refactored code
            vm.$onInit = function(){
                vm.booking = bookingService.get_booking_data();
                if(!vm.booking.booking_calendar_state || !vm.booking.slot.id){
                    $state.go("home.booking-calendar");
                    return false;
                }
                if(!vm.booking.patient) vm.booking.patient = {date_of_birth:new Date()};
                
                Http.get("v1/guest/location/"+vm.booking.location.id+"/clinics").then(function(res){
                    vm.clinics = res.data;
                });
            }
            vm.continue = function(){
                if(validate()){
                    vm.booking.profile_state = true;
                    bookingService.data = vm.booking;
                    bookingService.save();
                    $state.go("home.booking-review");
                }
            }
            //simplified validation
            function validate(){
                if(!vm.booking.patient.full_name){
                    alert("Please fill up your fullname");
                    return false;
                }
                if(!vm.booking.patient.id_number){
                    alert("Please fill up your ID number");
                    return false;
                }
                if(!vm.booking.patient.gender_id){
                    alert("Please Select Gender");
                    return false;
                }
                if(!vm.booking.patient.contact_number){
                    alert("Please fill up your contact number");
                    return false;
                }
                if(vm.booking.patient.q1 == undefined || vm.booking.patient.q2 == undefined){
                    alert("Please answer all survey");
                    return false;
                }
                if(!vm.booking.patient.clinic_id){
                    alert("Please select clinic");
                    return false;
                }
                return true
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
(function () {
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("dashboardBookingsController", dashboardBookingsController);

    dashboardBookingsController.$inject = ["Http", "Dashboard", "$state"];

    function dashboardBookingsController(Http, Dashboard, $state) {
        var vm = this;
        vm.is_ready = false;
        vm.is_visible = false;
        vm.status_index = 1;
        vm.location_id = 0;
        // vm.search_start_date = new Date();
        vm.status_list = [
            { index: 0, name: "Reserved" },
            { index: 1, name: "Confirmed" },
            { index: 2, name: "Missed" },
            { index: 3, name: "Completed" },
            { index: 4, name: "Cancelled" },
        ]

        Dashboard.init(function (data) {
            vm.portal = data;
        });

        vm.$onInit = function () {
            Http
                .get("v1/booking")
                .then(function (res) {
                    vm.bookings = res.data;
                    vm.location_list = res.data.location_list;
                    vm.location_list.push({ id: 0, name: "All sites" })
                    vm.is_ready = true;
                    vm.pagination_config = {
                        page_position: vm.portal.pagination,
                        total_items: vm.bookings.counts,
                        total_pages: vm.bookings.total_pages
                    }

                });
        }
        vm.reset_filters = function () {
            vm.bookingQuery = ""
            vm.status_index = 1;
            vm.location_id = 0;
            vm.filterBooking()
        }
        vm.paginate = function (page) {
            Http
                .post("v1/booking/paginate", { page: page, query: vm.bookingQuery, status_index: vm.status_index, location_id: vm.location_id })
                .then(
                    function (res) {
                        vm.bookings = res.data;
                    },
                    function (err) {
                        alert(err.data.message);
                        if(err.data.status == 403){
                            $state.go("admin");
                        }
                    }
                )
            vm.portal.pagination = page;
        }

        vm.filterBooking = function () {
            // .post("v1/booking/filter_booking", { query: vm.bookingQuery, status_index: vm.status_index, search_start_date: vm.search_start_date, search_end_date: vm.search_end_date })
            vm.is_ready = false;
            Http

                .post("v1/booking/filter_booking", { query: vm.bookingQuery, status_index: vm.status_index, location_id: vm.location_id })
                .then(
                    function (res) {
                        vm.bookings = res.data;
                        vm.pagination_config = {
                            page_position: vm.portal.pagination,
                            total_items: vm.bookings.counts,
                            total_pages: vm.bookings.total_pages
                        }
                        vm.is_ready = true;
                    },
                    function (err) {
                        alert(err.data.message);
                        if(err.data.status == 403){
                            $state.go("admin");
                        }
                    }
                )
        }
        vm.select_location = function () {
            vm.is_visible = !vm.is_visible
        }
        vm.closeDropdown = function () {
            vm.is_visible = false
        }

    }
})();
( function(){

	"use strict";

	angular
		.module('BiomarkBooking')
		.config(['$stateProvider','$urlRouterProvider','$locationProvider', function ($stateProvider, $urlRouterProvider, $locationProvider) {
			
    		$stateProvider
    			.state("admin.dashboard.bookings.view",{
		            url:"/view/:id",
		            template:"<booking-details></booking-details>",
				})
				
		}])

	
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("dashboardSidemenu",{
            controller:"dashboardSideMenuController",
            templateUrl:"/admin/dashboard/sidemenu/view.html",
            bindings:{
                services:"=",
            },
        })
})();
(function () {
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("dashboardSideMenuController", dashboardSideMenuController);

    dashboardSideMenuController.$inject = ["Http", "$state", "$localStorage"];

    function dashboardSideMenuController(Http, $state, $localStorage) {
        var vm = this;
        vm.control_ids = [1, 2, 4, 6]; // Service Ids

        vm.$onInit = function () {
            if($localStorage.selected_service) vm.active_index = $localStorage.selected_service
            // console.log(vm)
        }

        vm.set_active = function(index){
            $localStorage.selected_service = vm.active_index = index;
        }

        vm.isAllowed = function (controls) {
            for (var i = 0; i < controls.length; i++) {
                for (var x = 0; x < vm.control_ids.length; x++) {
                    if (controls[i].id == vm.control_ids[x]) {
                        if (controls[i].status) return true;
                    }
                }
            }
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
        .component("dashboardSettings",{
            controller:"dashboardSettingController",
            templateUrl:"/admin/dashboard/settings/view.html"
        })
})();
(function(){
    "use strict";


    angular
        .module("BiomarkBooking")
        .controller("dashboardSettingController",dashboardSettingController);

        dashboardSettingController.$inject = ["Http"];

        function dashboardSettingController(Http){
            var vm = this;
            vm.setting = {};
            vm.update = function(new_value,type){
                Http
                    .patch("v1/setting/update",{setting:{new_value:new_value,type:type}})
                    .then(function(res){
                        alert("updated");
                    });
            }
            vm.$onInit = function(){
                Http
                    .get("v1/setting")
                    .then(function(res){
                        vm.setting = res.data;
                    });
            }
        }
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
(function () {
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("dashboardUsersController", dashboardUsersController);

    dashboardUsersController.$inject = ["Http", "$state"];

    function dashboardUsersController(Http, $state) {
        var vm = this;

        vm.$onInit = function () {
            Http
                .get("v1/user")
                .then(
                    function (res) {
                        vm.user_list = res.data.users
                    },
                    function (err) {

                    })
        }
    }
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("bookingRescheduleCalendar",{
            controller:"bookingRescheduleCalendarController",
            templateUrl:"/admin/dashboard/bookings/booking-reschedule-calendar/view.html",
            bindings:{
                locationId: "=",
                closeModal:"=",
                bookingDetails: "="
            }
        })
})();
(function(){
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("bookingRescheduleCalendarController",bookingRescheduleCalendarController);

        bookingRescheduleCalendarController.$inject = ["$state","Http"];

        function bookingRescheduleCalendarController( $state, Http){
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
                if(slot.status){
                    vm.booking.slot = slot;
                }else if(slot.id == vm.bookingDetails.slot.id) {
                    vm.booking.slot = slot;
                }
            }
            vm.continue = function(){
                if(vm.booking.slot){
                    Http
                        .post("v1/booking/edit_booking",{past_booking_details: vm.bookingDetails, new_booking_details: vm.booking})
                        .then(
                        function(res){
                            vm.bookingDetails.schedule = res.data.schedule;
                            vm.bookingDetails.slot = res.data.slot;
                            vm.closeModal()
                        },
                        function(err){
                            console.log(err)
                        });
                    
                }else{  
                    alert("Please select slot");
                }
            }
            vm.$onInit = function(){
                vm.booking = { // Prefill selected time
                    slot: vm.bookingDetails.slot
                }
                Http
                    .get("v1/guest/location/"+vm.locationId+"/schedules")
                    .then(function(res){
                        vm.location = res.data;
                        //initialize selection
                        vm.booking.schedule = {id:vm.location.schedules[0].id, schedule_date:vm.location.schedules[0].schedule_date}
                    });
            }
        }
})();
(function () {
    "use strict";

    angular
        .module("BiomarkBooking")
        .component("bookingDetails", {
            controller: "bookingDetailsController",
            templateUrl:"/admin/dashboard/bookings/view/view.html"
        })
})();
(function () {
    "use strict";

    angular
        .module("BiomarkBooking")
        .controller("bookingDetailsController", bookingDetailsController);

    bookingDetailsController.$inject = ["$state", "Http"];

    function bookingDetailsController($state, Http) {
        var vm = this;

        vm.$onInit = function () {
            Http
                .get("v1/booking/" + $state.params.id).then(function (res) {
                    vm.booking_details = res.data.booking_details;
                    vm.patient_details = res.data.patient_details;
                    vm.question_details = res.data.question_details;
                });
        }



        vm.open_cancel_modal = function () {
            vm.cancel_modal = true;
        }
        vm.open_no_show_modal = function () {
            vm.no_show_modal = true;
        }
        vm.open_completed_modal = function () {
            vm.completed_modal = true;
        }
        vm.open_reschedule_modal = function(){
            vm.reschedule_modal = true;
        }

        vm.closeModal = function () {
            vm.cancel_modal = false;
            vm.no_show_modal = false;
            vm.completed_modal = false;
            vm.reschedule_modal = false;
        }

        vm.cancelBooking = function () {
            Http
                .post("v1/booking/cancel_booking", { id: $state.params.id })
                .then(function (res) {
                    vm.booking_details.payment_status = res.data.payment_status;
                    vm.cancel_modal = false;
                });
        }
        vm.markNoShow = function () {
            Http
                .post("v1/booking/mark_no_show", { id: $state.params.id })
                .then(function (res) {
                    vm.booking_details.payment_status = res.data.payment_status;
                    vm.no_show_modal = false;
                });
        }
        vm.markCompleted = function () {
            Http
                .post("v1/booking/mark_as_completed", { id: $state.params.id })
                .then(function (res) {
                    vm.booking_details.payment_status = res.data.payment_status;
                    vm.completed_modal = false;
                });
        }
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
            Http.get("v1/location/" + $state.params.id + "/clinics").then(function (res) {
                vm.clinics = res.data;
            });
        }

        vm.open_clinic_modal = function () {
            vm.location_clinic_modal = true;
            Http.get("v1/clinic").then(function (res) {
                vm.clinic_list = res.data;
            });
        }
        vm.cancel = function () {
            vm.location_clinic_modal = false;
        }

        vm.add_clinic = function (clinic_id) {
            Http
                .post("v1/location/"+$state.params.id+"/add_clinic",{clinic_id:clinic_id})
                .then(
                    function (res) {
                        vm.clinics.push(res.data);
                        vm.location_clinic_modal = false;
                    }, function (err) {
                       alert(err.data.message);
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
                Http.post("v1/schedule",{schedule:data}).then(function(res){
                    vm.generator_modal = false;
                    vm.generator = {};
                });    
            }
            vm.$onInit = function(){
                Http.get("v1/location/"+$state.params.id+"/schedules").then(function(res){
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
            
            vm.default_index = 0; //set initiali position to tab index 0
            vm.tabClicked = function(index){
                vm.default_index = index;
            }
            vm.tabs = [
                {
                    id:0,
                    name:"SCHEDULES"
                },
                {
                    id:1,
                    name:"CLINICS"
                },
                // {
                //     id:0,
                //     name:"USERS"
                // },
                
                

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
            var memcpy_slot;
            vm.getSlotInfo = function(slot){
                memcpy_slot = slot; //create slot binding
                Http.get("v1/schedule/"+vm.payload.id+"/slot/"+slot.id).then(function(res){
                    vm.slot = res.data;
                });
            }
            vm.closeSlot = function(slot, index ){
                Http.post("v1/schedule/"+vm.payload.id+"/close_slot/"+slot.id).then(function(res){
                    //set reference memory state from array
                    //make the slot state to unavailable
                    memcpy_slot.status = false; 
                    //set active state since memcpy no longer use the original mem address
                    //make the button close gone
                    vm.slot.status = false; 
                });
            }
            vm.$onInit = function(){
                Http.get("v1/schedule/"+vm.payload.id).then(function(res){
                    vm.slots = res.data.active_slot.data;
                });
            }
        }
})();