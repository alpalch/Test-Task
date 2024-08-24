/**
 * @author            : ValeriyPalchenko
 * @ticket reference  : 
 * @Created on        : 24-08-2024
 * @last modified on  : 24-08-2024
 * @last modified by  : ValeriyPalchenko
**/
public with sharing class RollupCaseService {

  private List<Case> cases;

  private Map<Id, List<Case>> openCasesByAccountId;
  private Map<Id, List<Case>> closedCasesByAccountId;

  public RollupCaseService(List<Case> cases) {
    this.cases = cases;
  }

  public void runRollups() {
    try {
      countOpenAndClosedCasesByAccount();
    } catch (Exception ex) {
      throw new HandledException(ex.getMessage());
    }
  }

  private void countOpenAndClosedCasesByAccount() {
    Set<Id> accountIds = new Set<Id>();
    for (Case newCase :this.cases) {
      accountIds.add(newCase.AccountId);
    }

    this.cases = getCasesByAccountId(accountIds);

    sortCasesByClosedStatus();

    List<Account> accounts = createAccountsForUpdate(accountIds);

    if (!accounts.isEmpty()) {
      update accounts;
    }
  }

  private void sortCasesByClosedStatus() {
    this.openCasesByAccountId = new Map<Id, List<Case>>();
    this.closedCasesByAccountId =  new Map<Id, List<Case>>();

    for (Case newCase :this.cases) {
      if (newCase.IsClosed) {
        if (!closedCasesByAccountId.containsKey(newCase.AccountId)) {
          closedCasesByAccountId.put(newCase.AccountId, new List<Case>());
        }
        closedCasesByAccountId.get(newCase.AccountId).add(newCase);
      } else {
        if (!openCasesByAccountId.containsKey(newCase.AccountId)) {
          openCasesByAccountId.put(newCase.AccountId, new List<Case>());
        }
        openCasesByAccountId.get(newCase.AccountId).add(newCase);
      }
    }
  }

  private List<Account> createAccountsForUpdate(Set<Id> accountIds) {
    List<Account> accounts = new List<Account>();

    for (Id accountId :accountIds) {
      Account account = new Account(
        Id = accountId,
        NumberOfClosedCases__c = closedCasesByAccountId.get(accountId)?.size(),
        NumberOfOpenCases__c = openCasesByAccountId.get(accountId)?.size()
      );
        
      if (account.NumberOfClosedCases__c == null) {
        account.NumberOfClosedCases__c = 0;
      }
        
      if (account.NumberOfOpenCases__c == null) {
        account.NumberOfOpenCases__c = 0;
      }

      accounts.add(account);
    }

    return accounts;
  }

  private List<Case> getCasesByAccountId(Set<Id> accountIds) {
    return [SELECT Id, AccountId, isClosed
            FROM Case
            WHERE AccountId IN :accountIds];
  }
}