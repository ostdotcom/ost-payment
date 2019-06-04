ostPayments.braintree.client.create({customerId: "customerID"}, function (err, clientInstance) {

    ostPayments.braintree.customFields.create({
        client: clientInstance,
        styles: {
            'input': {
                'font-size': '14px',
                'font-family': 'helvetica, tahoma, calibri, sans-serif',
                'color': '#3a3a3a'
            },
            ':focus': {
                'color': 'black'
            }
        },
        fields: {
            number: {
                selector: '#card-number',
                placeholder: '4111 1111 1111 1111'
            },
            cvv: {
                selector: '#cvv',
                placeholder: '123'
            },
            expirationMonth: {
                selector: '#expiration-month',
                placeholder: 'MM'
            },
            expirationYear: {
                selector: '#expiration-year',
                placeholder: 'YY'
            },
            postalCode: {
                selector: '#postal-code',
                placeholder: '90210'
            }
        },
    }, function (err, customFieldsInstance) {

        $('.panel-body').submit(function (event) {
            event.preventDefault();
            customFieldsInstance.tokenize(function (err, payload) {
                if (err) {
                    console.error(err);
                    return;
                }
                console.log(payload, "======= ------ ====== ------- payload ======= ------ ====== -------");

            });
        });


    });
    console.log("err", err);
    console.log("clientInstance", clientInstance);
});