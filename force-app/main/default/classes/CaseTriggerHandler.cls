/**
 * @author            : ValeriyPalchenko
 * @ticket reference  : 
 * @Created on        : 24-08-2024
 * @last modified on  : 24-08-2024
 * @last modified by  : ValeriyPalchenko
**/
public with sharing class CaseTriggerHandler {

  private List<Case> cases;

  public CaseTriggerHandler(List<Case> cases) {
    this.cases = cases;
  }

  public void onAfterInsert() {
    new RollupCaseService(this.cases).runRollups();
  }

  public void onAfterUpdate() {
    new RollupCaseService(this.cases).runRollups();
  }

  public void onAfterDelete() {
    new RollupCaseService(this.cases).runRollups();
  }

  public void onAfterUndelete() {
    new RollupCaseService(this.cases).runRollups();
  }
}