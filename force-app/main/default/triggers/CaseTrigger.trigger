/**
 * @author            : ValeriyPalchenko
 * @ticket reference  : 
 * @Created on        : 24-08-2024
 * @last modified on  : 24-08-2024
 * @last modified by  : ValeriyPalchenko
**/
trigger CaseTrigger on Case (after insert, after update, after delete, after undelete) {

  if (Trigger.isInsert) {
    new CaseTriggerHandler().onAfterInsert(Trigger.new);
  }

  if (Trigger.isUpdate) {
    new CaseTriggerHandler().onAfterUpdate(Trigger.new);
  }

  if (Trigger.isDelete) {
    new CaseTriggerHandler().onAfterDelete(Trigger.old);
  }

  if (Trigger.isUndelete) {
    new CaseTriggerHandler().onAfterUndelete(Trigger.new);
  }
}