/**
 * Churn jasmine test spec file.
 * 
 */
 
describe("getRESTData component testing", function(){
    afterEach(function() {
        // Each spec (test) renders its components into the same div,
        // so we need to clear that div out at the end of each spec.
        $T.clearRenderedTestComponents();
    });

    describe("Invoke local action", function() {
        beforeEach(function(done) {
            var that = this;
            $T.createComponent("c:getRESTData", { customerId:46 }, true).then(function(component) {
                that.component = component;
                $T.run(function() { 
                    component.invoke($A.getCallback(function(status, errorMessage) {
                        that.status = status;
                        that.errorMessage = errorMessage;
                        done();
                    }));
                });
            });
        });
        it("verify output value", function() {
            expect(this.status).toBe("SUCCESS");
            expect(this.component.get("v.churnVal")).toBe(0.85);
        });
    });

});
