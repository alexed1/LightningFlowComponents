/**
 * @description       : Simple factory to instantiate FindDuplicates() so we can mock tests.
 * @group             : UnofficialSF
 * @last modified on  : 01-28-2022
 * Modifications Log
 * Ver   Date         Modification
 * 1.0   01-28-2022   Initial Version
**/
public with sharing virtual class FindDuplicatesFactory {
    @TestVisible
    private static FindDuplicatesFactory stubFactory;
    private static FindDuplicatesFactory factory;

    protected FindDuplicatesFactory() {}

    public static FindDuplicatesFactory getFactory() {
        if (stubFactory != null) {
            return stubFactory;
        } else if (factory == null) {
            factory = new FindDuplicatesFactory();
        }

        return factory;
    }

    public virtual FindDuplicates getFindDuplicates(){
        return new FindDuplicates();
    }
}
