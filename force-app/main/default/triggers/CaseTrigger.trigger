/**
 * @author            : ValeriyPalchenko
 * @ticket reference  : 
 * @Created on        : 24-08-2024
 * @last modified on  : 24-08-2024
 * @last modified by  : ValeriyPalchenko
**/
trigger CaseTrigger on Case (after insert, after update, after delete, after undelete) {

  if (Trigger.isInsert) {
    new CaseTriggerHandler(Trigger.new).onAfterInsert();
  }

  if (Trigger.isUpdate) {
    new CaseTriggerHandler(Trigger.new).onAfterUpdate();
  }

  if (Trigger.isDelete) {
    new CaseTriggerHandler(Trigger.old).onAfterDelete();
  }

  if (Trigger.isUndelete) {
    new CaseTriggerHandler(Trigger.new).onAfterUndelete();
  }
}