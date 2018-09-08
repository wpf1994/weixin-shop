/**
 * Created by tavern on 16/5/25.
 */


//{name: "", url:"", query:""}
window.free_express_vue = function (page) {
    new Vue({
        el: "#fress_express_page",
        data: {
            express: {}
        },
        methods: {
            address_selector_changed: function (value) {
                if (value == "")
                    return;
                // 从获取的地址中,自动填写好相应的字段
                this.$http({url: '/get_addr/' + value, method: 'GET'}).then(function (data) {
                    data = data.data;
                    Vue.set(this.express, 'name', data.name);
                    Vue.set(this.express, 'phone', data.phone);
                    if (data.shop_id)
                        Vue.set(this.express, 'shop_id', data.shop_id);
                    Vue.set(this.express, 'address', data.address);

                }, function (response) {
                });
            },
            // 保存快递信息
            save_express: function () {
                var message = [];
                if (!this.express.name || this.express.name.length == 0)
                    message.push('请填写收货人姓名');
                if (!this.express.phone || this.express.phone.length == 0)
                    message.push('请填写收货人电话');
                if (!this.express.shop_id || this.express.shop_id.length == 0)
                    message.push('请选择包裹所在地');
                if (!this.express.address || this.express.address.length == 0)
                    message.push('请填写收货地址');

                if (message.length > 0) {
                    window.f7.app.alert(message.join(','), '校验失败');
                    return
                }

                this.$http.post('/save_addr', {express: this.express}).then(function (data) {
                    window.f7.app.alert('提交成功', '成功', function () {
                        window.f7.mainView.router.back()
                    });
                }, function (response) {
                    window.f7.app.alert(response.data.message, '失败');
                })
            },
            //判断是否能提交
            can_submit: function () {
            }
        },
        ready: function () {
        }
    })
};
window.f7 = new Vue({
    el: 'html',
    data: {
        app: null,
        swiper: null,
        mainView: null
    },
    methods: {
        free_express_click: function () {
            this.mainView.router.loadPage('/free_express');
        }
    },
    ready: function () {
        var $that = this;
        this.app = new Framework7({
            onPageInit: function (app, page) {
                if (page.name == 'free_express') {
                    free_express_vue(page)
                }
                else if (page.name == 'home') {
                    // 异步加载完幻灯片
                    setTimeout(function () {
                        this.swiper = $that.app.swiper('.swiper-container', {
                            speed: 400,
                            lazyLoading: true,
                            spaceBetween: 0,
                            pagination: '.swiper-pagination'
                        });
                    })
                }
            }
        });

        this.mainView = this.app.addView('.view-main', {});
    }
});

