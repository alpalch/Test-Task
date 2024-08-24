/**
 * @author            : ValeriyPalchenko
 * @ticket reference  : 
 * @Created on        : 24-08-2024
 * @last modified on  : 24-08-2024
 * @last modified by  : ValeriyPalchenko
**/
public with sharing class CaseTriggerHandler {

  public CaseTriggerHandler() {}

  public void onAfterInsert(List<Case> cases) {
    new RollupCaseService(cases).runRollups();
  }

  public void onAfterUpdate(List<Case> cases) {
    new RollupCaseService(cases).runRollups();
  }

  public void onAfterDelete(List<Case> cases) {
    new RollupCaseService(cases).runRollups();
  }

  public void onAfterUndelete(List<Case> cases) {
    new RollupCaseService(cases).runRollups();
  }
}