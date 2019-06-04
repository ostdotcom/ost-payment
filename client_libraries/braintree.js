(function () {
    var ostPaymentDomain = "http://payment.developmentost.com:8080";
    ostPayments = {
        braintree: {
            client: {
                create: function (params, callback) {
                    params = params || {};
                    $.getScript("https://js.braintreegateway.com/web/3.45.0/js/hosted-fields.min.js", function () {
                        $.ajax({
                            url: ostPaymentDomain + "/api/braintree/get-token",
                            data: { customerId: params.customerId },
                            type: "POST",
                            success: function (res) {
                                braintree.client.create({
                                    authorization: res.data.gateway_token
                                }, function (err, clientInstance) {
                                    callback(err, clientInstance);
                                });

                            },
                            error: function (err) {
                                callback(null, err);
                            }
                        });
                    });
                },
            },

            customFields: {
                create: function (params, createCallback) {
                    var oThis = this,
                        client = params.client,
                        styles = params.styles,
                        fields = params.fields;

                    braintree.hostedFields.create({
                            client: client,
                            styles: styles,
                            fields: fields
                        },
                        function (err, hostedFieldsInstance) {
                            if (err) {
                                console.log(err);
                                return err;
                            }
                            let clonedObject = Object.assign({}, hostedFieldsInstance);
                            var overiddingObj = {

                                tokenize: function (callback) {

                                    hostedFieldsInstance.tokenize(function (err, payload) {

                                        if (err) {
                                            console.error(err);
                                            callback(err, null);
                                            return;
                                        }
                                        $.ajax({
                                            url: ostPaymentDomain + "/api/braintree/save-nounce",
                                            data: payload,
                                            type: "POST",
                                            success: function (payload) {
                                                callback(null, payload);
                                            }
                                        });
                                    });
                                    if (err) {
                                        console.error(err);
                                        callback(err, null);
                                    }
                                }
                            };
                            Object.assign(clonedObject, overiddingObj);


                            createCallback(err, clonedObject);

                        });
                }
            },

        }
    }
}());