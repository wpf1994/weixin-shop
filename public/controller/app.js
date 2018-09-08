/**
 * Created by Administrator on 2015/6/29 0029.
 */

Array.prototype.remove = function (obj) {
    if (typeof obj == "number") {
        return this.splice(obj, 1);
    }
    else {
        var index = this.indexOf(obj);
        if (index > -1)
            return this.splice(index, 1);
    }
}

angular.module('myapp', ['ngRoute', 'infinite-scroll'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider
            .when('/', {
                controller: 'shipping_selected',
                templateUrl: '/pages/index.html'
            })
            .when('/pages/shop', {
                controller: 'shop_selected',
                templateUrl: '/pages/shop.html'
            })
            .when('/pages/order_submit', {
                controller: 'order_manage',
                templateUrl: '/pages/order.html'
            })
            .when('/pages/address_info', {
                controller: 'address_info',
                templateUrl: '/pages/address.html'
            })
            .when('/pages/create_address', {
                controller: 'address_create',
                templateUrl: '/pages/address_create.html'
            })
            .when('/pages/person_info', {
                controller: 'person_info',
                templateUrl: '/pages/person_info.html'
            })
            .when('/pages/score_detail', {
                controller: 'score_detail',
                templateUrl: '/pages/score_detail.html'
            })
            .when('/pages/edit_address_new', {
                controller: 'edit_address_manage',
                templateUrl: '/pages/edit_address.html'
            })
            .when('/pages/order_detail', {
                controller: 'order_detail',
                templateUrl: '/pages/order_detail.html'
            })
            .when('/pages/person_edit', {
                controller: 'person_edit',
                templateUrl: '/pages/person_edit'
            })
            .when('/pages/search', {
                controller: 'search_shipping',
                templateUrl: '/pages/search'
            })

    }])
    .controller('Mycontroller', function ($rootScope, $http) {
        $rootScope.shop_id = null
        $rootScope.express_amount = 0
        $rootScope.consume_amount = 0
        $rootScope.class_id = 4
        $rootScope.buy_shipping = {}
        $rootScope.total_price = 0
        $rootScope.shipping_num = 0
        $rootScope.receving_address = null
        $rootScope.select_address_value = 0
        $rootScope.now_shop_id = 0
        $rootScope.class_page = {}
    })
    .controller('shipping_selected', function ($scope, $http, $location, $rootScope) {
        if(!$rootScope.shop_id){
            $location.path('/pages/shop')
        }
        $scope.click_shop = 0
        $scope.per = 10
        $scope.show_car = false
        $scope.busy = false
        $rootScope.commodity = $rootScope.commodity || {}
        $scope.select_class_name = ''
        $scope.children_class_isselect = 0
        //获取选择类下面的商品
        $http.get("/front/homes/get_classification.json")
            .success(function (data) {
                $scope.class_name = data.classifications
                $scope.Is_select_class = data.classifications[0].id
                $scope.children_class_isselect = data.classifications[0].id
                $rootScope.class_id = $scope.class_name[0].id
                $rootScope.class_page[$rootScope.class_id] = $rootScope.class_page[$rootScope.class_id] || 0
                $scope.select_class_name = $scope.class_name[0].name
                tempload()
                $scope.next_pages = tempload
            })
            .error(function (error) {
                console.log(error)
            })
        function tempload() {
            //if ($rootScope.commodity[$rootScope.class_id])
            //    return
            if ($scope.busy) return;
            $scope.busy = true;
            if($rootScope.class_page[$rootScope.class_id] != null){
                $rootScope.class_page[$rootScope.class_id] +=1
            }else{
                $rootScope.class_page[$rootScope.class_id] = 0
            }
            $http.get("/front/homes/home_index.json?page=" + $rootScope.class_page[$rootScope.class_id] + "&per=" + $scope.per + "&shop_id=" + $rootScope.shop_id + "&class_id=" + $rootScope.class_id + "")
                .success(function (data) {
                    if (data.length > 0) {
                        $rootScope.commodity[$rootScope.class_id] = $rootScope.commodity[$rootScope.class_id] || []
                        $rootScope.commodity[$rootScope.class_id] = $rootScope.commodity[$rootScope.class_id].concat(data)
                        //console.log($rootScope.commodity)
                        $scope.busy = false
                    }
                })
                .error(function (error) {
                    console.log(error)
                })
        }

        $scope.close_shop_car = function () {
            if ($scope.show_car == true) {
                $scope.show_car = false
            }
        }
        $scope.search_shipping = function () {
            $location.path('/pages/search')
        }
        $scope.select_children_class = function (data) {
            $scope.children_class_isselect = data
            $rootScope.class_id = data
            $scope.busy = false
            //$scope.commodity = []
            $rootScope.class_page[$rootScope.class_id] = $rootScope.class_page[$rootScope.class_id] || 0
            $scope.next_pages()
        }
        $scope.person = function () {
            $location.path('/pages/person_info')
        }
        $scope.slect_class = function (data) {
            $scope.children_class_isselect = data.id
            $scope.Is_select_class = data.id
            $rootScope.class_id = data.id
            $scope.select_class_name = data.name
            $scope.busy = false
            //$scope.commodity = []
            $rootScope.class_page[$rootScope.class_id] = $rootScope.class_page[$rootScope.class_id] || 0
            $scope.next_pages()
        }
        $scope.change_shop = function () {
            $location.path('/pages/shop')
        }
        function is_include(sqwrt) {
            temp = false
            if ($rootScope.buy_shipping[$scope.select_class_name].length > 0) {
                angular.forEach($rootScope.buy_shipping[$scope.select_class_name], function (data) {
                    if (data.id == sqwrt.id) {
                        //if(data.class_id != sqwrt.class_id){
                        //    data.num +=1
                        //    sqwrt.num = data.num
                        //}
                        data.num +=1
                        temp = true
                        return temp
                    }
                })
            }
            return temp
        }

        $scope.select_commoidty = function (data) {
            //$scope.click_shop = data.id
            //data.num += 1
            data.class_id = $rootScope.class_id
            $rootScope.buy_shipping[$scope.select_class_name] = $rootScope.buy_shipping[$scope.select_class_name] || []
            if (!is_include(data)) {
                $rootScope.buy_shipping[$scope.select_class_name].push(data)
            }
            $rootScope.shipping_num += 1
            $rootScope.total_price += data.shop_commodities.price
        }
        $scope.shop_car = function () {
            $scope.show_car = !$scope.show_car
        }
        function calcu_price() {
            angular.forEach($rootScope.buy_shipping, function (data) {
                angular.forEach(data, function (mata) {
                    $rootScope.total_price += mata.num * mata.shop_commodities.price
                })
            })
        }

        $scope.num_add = function (data) {
            data.num += 1
            $rootScope.shipping_num += 1
            $rootScope.total_price = 0
            calcu_price()
        }
        $scope.num_down = function (data) {
            if (data.num != 1) {
                data.num -= 1
                $rootScope.shipping_num -= 1

                $rootScope.total_price = 0
                calcu_price()
            }
        }
        $scope.calcu_total = function () {
            $rootScope.total_price = 0
            calcu_price()
        }
        $scope.remove_shipping = function (data, name, temp) {
            $rootScope.shipping_num -= temp.num
            $rootScope.buy_shipping[name].remove(data)
            //console.log($rootScope.buy_shipping[name].length)
            if ($rootScope.buy_shipping[name].length == 0) {
                delete $rootScope.buy_shipping[name]
                //console.log($rootScope.buy_shipping)
            }
            $scope.$$phase || $scope.$apply()
            $rootScope.total_price = 0
            calcu_price()
        }
        function isNull(value) {
            return Object.keys(value).length === 0;
        }

        localforage.getItem('user_order', function (err, value) {
            console.log(value)
        });

        $scope.down_order = function () {
            if ($rootScope.buy_shipping) {
                $location.path('/pages/order_submit')
            }
        }
    })
    .controller('shop_selected', function ($scope, $http, $location, $rootScope) {
        //$scope.shop_info = {}
        $http.get("/front/homes/get_region_shop.json")
            .success(function (data) {
                $scope.area_shop = data
                if ($rootScope.now_shop_id == 0) {
                    $rootScope.now_shop_id = data[0].shop_area.shops[0].id
                }
                //$scope.area_id = $scope.area_shop[0]
                //$scope.region_id = $scope.area_shop[0].id
                //$scope.submit_shop = $scope.area_shop[0].name
                //shop_get()
                //$scope.get_shop = shop_get
            })
            .error(function (error) {
                console.log(error)
            })

        //function shop_get() {
        //    if ($scope.busy) return;
        //    $scope.busy = true;
        //    $scope.page +=1
        //    $http.get("/front/homes/get_shop.json?region_id=" + $scope.region_id + "&page=" + $scope.page + "&per=" + $scope.per + "")
        //        .success(function (data) {
        //            if(data.shop.length > 0) {
        //                $scope.shop_info.push(data.shop)
        //                $scope.busy = false
        //            }
        //        })
        //        .error(function (error) {
        //            console.log(error)
        //        })
        //}

        $scope.selected_shop = function (data) {
            $rootScope.shop_id = data.id
            $rootScope.now_shop_id = data.id
            if(data.name.length > 4){
                $rootScope.shop_name = data.name.substr(0,3) + '...'
            }else{
                $rootScope.shop_name = data.name
            }
            $rootScope.express_amount = data.express_amount
            $rootScope.consume_amount = data.consume_amount
            $rootScope.buy_shipping = {}
            $rootScope.shipping_num = 0
            $rootScope.total_price = 0
            //清空分页
            $rootScope.class_page = []
            //清空商品数据
            $rootScope.commodity = []
            $location.path('/')
        }
    })
    .controller('order_manage', function ($scope, $http, $location, $rootScope, $timeout) {
        if ($rootScope.receving_address == null) {
            $http.get("/front/homes/shipping_address_default.json")
                .success(function (data) {
                    if (data.receiving_address != null) {
                        $rootScope.receving_address = data.receiving_address
                        $rootScope.select_address_value = data.receiving_address.id
                        //console.log($rootScope.select_address_value)
                        $scope.is_show = true
                    }
                    else {
                        $rootScope.receving_address = null
                        $scope.is_show = false
                    }
                })
                .error(function (error) {
                    console.log(error)
                })
        }
        else {
            $scope.is_show = true
        }
        //alert($rootScope.buy_shipping)
        $scope.write_address = function () {
            $location.path('/pages/address_info')
        }
        $scope.submit_order_to_down = function () {
            if (!$scope.is_show) {
                return
            }
            $rootScope.shop_id = $rootScope.shop_id || null
            $http.post("/front/homes/order_new.json", {
                order: {
                    shop_id: $rootScope.shop_id,
                    commodity_amount: $rootScope.total_price,
                    express_amount: $rootScope.express_amount,
                    consume_amount: $rootScope.consume_amount
                }, order_detail: {shipping: $rootScope.buy_shipping}, order_express: $rootScope.receving_address
            })
                .success(function (data) {
                    if (data.result == "OK") {
                        $scope.message_info_show = true
                         $rootScope.buy_shipping = {}
                         $rootScope.total_price = 0
                         $rootScope.shipping_num = 0
                        angular.forEach($rootScope.commodity, function(data){
                            angular.forEach(data, function(temp){
                                temp.commodity.num=0
                            })
                        })

                         //$rootScope.class_page = {}
                        $timeout(function () {
                            $location.path('/pages/person_info')
                        }, 1000)
                    }
                })
                .error(function (error) {
                    console.log(error)
                })
        }
    })
    .controller('address_info', function ($scope, $http, $location, $rootScope) {
        $http.get("/front/homes/shipping_address.json")
            .success(function (data) {
                $scope.address_info = data.receiving_address
            })
            .error(function (error) {
                console.log(error)
            })
        $scope.create_address = function () {
            $location.path('/pages/create_address')
        }
        $scope.select_address = function (data) {
            $rootScope.receving_address = data
            $rootScope.select_address_value = data.id
            $location.path('/pages/order_submit')
        }
        $scope.change_address = function (data) {
            $rootScope.edit_address_info = data
            $location.path('/pages/edit_address_new')
        }
    })
    .controller('address_create', function ($scope, $http, $location, $rootScope) {
        $scope.create_address = function () {
            $http.post("/front/homes/shipping_address_new.json", {receiving_address: ($scope.receiving_address)})
                .success(function (data) {
                    if (data.result == 'OK') {
                        $rootScope.select_address_value = data.result_address_id
                        $location.path('/pages/order_submit')
                    }
                    else {
                        alert("错误")
                    }
                })
                .error(function (error) {
                    console.log(error)
                })
        }
    })
    .controller('person_info', function ($scope, $http, $location, $rootScope) {
        $scope.page = 0;
        $scope.per = 5;
        $scope.busy = false
        $scope.order_old = []
        $scope.order_comment = {}
        $scope.order_status = {
            '0': "用户下单",
            '1': "等待支付",
            '2': "等待确认",
            '3': "等待配送",
            '4': "配送中",
            '5': "待评价",
            '6': "已评价",
            '-1': "用户撤单",
            '-2': "商家撤单",
            '-3': "订单过期自动关闭"
        }
        $scope.review_view = function () {
            $scope.order_comment.total_star = $('#asb').find("input[name=score]").val()
            $scope.order_comment.speed_star = $('#bsb').find("input[name=score]").val()
            $scope.order_comment.serve_start = $('#csb').find("input[name=score]").val()

            $http.post('/front/homes/commentary_order.json', {order_comment: $scope.order_comment})
                .success(function (data) {
                    if (data.result == "OK") {
                        alert("谢谢你的评价")
                        location.reload();
                    }
                })
                .error(function (error) {
                    console.log(error)
                })
            $scope.review_show = false
        }
        $scope.hide_table = function () {
            $scope.review_show = false
        }
        $scope.change_user_name = function () {
            $scope.text_show = !$scope.text_show
        }
        $scope.text_show = true
        $scope.gagahah = function () {
            $location.path('/pages/person_edit')
        }
        $scope.result_show_review = function (data) {
            $scope.review_show = true
            $scope.order_comment.order_id = data.id
            $scope.order_comment["shop_id"] = data.shop_id

        }
        $scope.detail_score = function () {
            $location.path('/pages/score_detail')
        }
        $scope.order_detail_info = function (data) {
            $rootScope.order_id = data.id
            $rootScope.order_total = data.commodity_amount
            $rootScope.isActive = data.status
            $location.path('/pages/order_detail')
        }
        $scope.comment = function (data) {
            $http.post('/pages/homes/')
        }
        $http.get('/front/homes/get_person_info.json')
            .success(function (data) {
                $scope.person = data.person_info
                $rootScope.person_name = $scope.person.name || "用户_" + $scope.person.id
                $rootScope.score = $scope.person.score
            })
            .error(function (error) {
                console.log(error)
            })
        $scope.nextPage = function () {
            $scope.page += 1
            if ($scope.busy) return;
            $scope.busy = true;
            $http.get("/front/homes/get_order_old.json?&page=" + $scope.page + "&per=" + $scope.per + "")
                .success(function (data) {
                    if (data.order_info.length > 0) {
                        $scope.order_old = $scope.order_old.concat(data.order_info)
                        $scope.busy = false

                    }
                })
                .error(function (error) {
                    console.log(error)
                })
        }
        $http.get("/front/homes/get_order_ing.json")
            .success(function (data) {
                $scope.order_ing = data.order_info
            })
            .error(function (error) {
                console.log(error)
            })
    })
    .controller('score_detail', function ($scope, $http, $location, $rootScope) {
        $http.get("/front/homes/get_score_detail.json")
            .success(function (data) {
                $scope.score_all = $rootScope.score
                $scope.score_record = data.score_record
            })
            .error(function (error) {
                console.log(error)
            })
    })
    .controller('order_detail', function ($scope, $http, $location, $rootScope) {
        $http.get("/front/homes/get_order_detail.json?order_id=" + $rootScope.order_id + "")
            .success(function (data) {
                $scope.order_detail = {}
                angular.forEach(data.order_detail, function (sta) {
                    $scope.order_detail[sta.commodity.classification.name] = $scope.order_detail[sta.commodity.classification.name] || []
                    $scope.order_detail[sta.commodity.classification.name].push(sta)
                })
                $scope.order_expresss = data.order_expresss
                $scope.order_info = data.order_info
            })
            .error(function (error) {
                console.log(error)
            })
        $scope.cancel_order = function () {
            $http.get("/front/homes/cancel_order_customer.json?order_id=" + $rootScope.order_id + "")
                .success(function (data) {
                    if (data.result == "OK") {
                        $location.path('/pages/person_info')
                    }
                })
        }
    })
    .controller('edit_address_manage', function ($scope, $http, $location, $rootScope) {
        $scope.submit_edit_address = function () {
            $http.post("/front/homes/shipping_address_change.json", {receiving_address: ($rootScope.edit_address_info)})
                .success(function (data) {
                    if (data.result == 'OK') {
                        $rootScope.select_address_value = data.result_address_id
                        alert("修改成功")
                        $location.path('/pages/address_info')
                    }
                    else {
                        alert("错误")
                    }
                })
                .error(function (error) {
                    console.log(error)
                })
        }
    })
    .controller('person_edit', function ($scope, $http, $location, $rootScope) {
        $scope.person_info = {
            name: ''
        }
        $scope.person_info.name = $rootScope.person_name
        $scope.change_person_info = function () {
            if ($scope.person_info.name == "") {

                return
            }
            $http.post('/front/homes/change_person_info', {person_info: $scope.person_info})
                .success(function (data) {
                    if (data.result == "OK") {
                        alert("保存成功!")
                        $location.path('/pages/person_info')
                    }
                })
                .error(function (error) {
                    console.log(error)
                })
        }
    })
    .controller('search_shipping', function ($scope, $http, $location, $rootScope) {
        $scope.search_now = function () {
            $rootScope.shop_id = $rootScope.shop_id || null
            $http.post('/front/homes/search_shipping_info.json', {
                shipping_name: $scope.shipping_name,
                shop_id: $rootScope.shop_id
            })
                .success(function (data) {
                    $scope.commodity_list = data
                })
                .error(function (error) {
                    console.log(error)
                })
        }
        function is_include(sqwrt) {
            temp = false
            if ($rootScope.buy_shipping[sqwrt.class_name].length > 0) {
                angular.forEach($rootScope.buy_shipping[sqwrt.class_name], function (data) {
                    if (data.id == sqwrt.id) {
                        //if(data.class_id != sqwrt.class_id){
                        //    data.num +=1
                        //    sqwrt.num = data.num
                        //}
                        data.num +=1
                        temp = true
                        return temp
                    }
                })
            }
            return temp
        }

        $scope.select_commoidty = function (data) {
            $rootScope.shipping_num += 1
            $rootScope.total_price += data.shop_commodities.price
            $rootScope.buy_shipping[data.class_name] = $rootScope.buy_shipping[data.class_name] || []
            if (!is_include(data)) {
                $rootScope.buy_shipping[data.class_name].push(data)
            }
        }
    })


