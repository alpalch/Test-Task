/**
 * @author            : ValeriyPalchenko
 * @ticket reference  : 
 * @Created on        : 24-08-2024
 * @last modified on  : 24-08-2024
 * @last modified by  : ValeriyPalchenko
**/
@isTest
private with sharing class RollupCaseServiceTest {
  
  @TestSetup
  static void makeData() {
    TestDataFactory factory = new TestDataFactory();
    List<Account> accounts = factory.createTestObjects(Account.getSObjectType(), 1, true);
  }

  @isTest
  private static void insertTest() {
    // Given
    TestDataFactory factory = new TestDataFactory();
    Account account = [SELECT Id FROM Account LIMIT 1];
    List<Case> cases = factory.createTestObjects(Case.getSObjectType(), 10, false);
    for (Case newCase :cases) {
      newCase.AccountId = account.Id;
      if (cases.indexOf(newCase) < 5) {
        newCase.Status = 'Closed';
      }
    }

    // When
    Test.startTest();
    insert cases;
    Test.stopTest();

    // Then
    Account toAssert = [SELECT Id, NumberOfClosedCases__c, NumberOfOpenCases__c
                        FROM Account
                        LIMIT 1];
    System.assertEquals(5, toAssert.NumberOfOpenCases__c);
    System.assertEquals(5, toAssert.NumberOfClosedCases__c);
  }

  @isTest
  private static void updateTest() {
    // Given
    TestDataFactory factory = new TestDataFactory();
    Account account = [SELECT Id FROM Account LIMIT 1];
    List<Case> cases = factory.createTestObjects(Case.getSObjectType(), 10, false);
    for (Case newCase :cases) {
      newCase.AccountId = account.Id;
    }
    insert cases;

    for (Case newCase :cases) {
      if (cases.indexOf(newCase) < 3) {
        newCase.Status = 'Closed';
      }
    }

    // When
    Test.startTest();
    update cases;
    Test.stopTest();

    // Then
    Account toAssert = [SELECT Id, NumberOfClosedCases__c, NumberOfOpenCases__c
                       FROM Account
                       LIMIT 1];
    System.assertEquals(7, toAssert.NumberOfOpenCases__c);
    System.assertEquals(3, toAssert.NumberOfClosedCases__c);
  }

  @isTest
  private static void deleteTest() {
    // Given
    TestDataFactory factory = new TestDataFactory();
    Account account = [SELECT Id FROM Account LIMIT 1];
    List<Case> cases = factory.createTestObjects(Case.getSObjectType(), 10, false);
    for (Case newCase :cases) {
      newCase.AccountId = account.Id;
      if (cases.indexOf(newCase) < 3) {
        newCase.Status = 'Closed';
      }
    }
    insert cases;

    List<Case> toDelete = new List<Case>{ cases[0], cases[7] };

    // When
    Test.startTest();
    delete toDelete;
    Test.stopTest();

    // Then
    Account toAssert = [SELECT Id, NumberOfClosedCases__c, NumberOfOpenCases__c
                       FROM Account
                       LIMIT 1];
    System.assertEquals(6, toAssert.NumberOfOpenCases__c);
    System.assertEquals(2, toAssert.NumberOfClosedCases__c);
  }

  @isTest
  private static void undeleteTest() {
    // Given
    TestDataFactory factory = new TestDataFactory();
    Account account = [SELECT Id FROM Account LIMIT 1];
    List<Case> cases = factory.createTestObjects(Case.getSObjectType(), 10, false);
    for (Case newCase :cases) {
      newCase.AccountId = account.Id;
      if (cases.indexOf(newCase) < 3) {
        newCase.Status = 'Closed';
      }
    }
    insert cases;

    List<Case> toDelete = new List<Case>{ cases[0], cases[7] };
    delete toDelete;

    // When
    Test.startTest();
    undelete toDelete;
    Test.stopTest();

    // Then
    Account toAssert = [SELECT Id, NumberOfClosedCases__c, NumberOfOpenCases__c
                       FROM Account
                       LIMIT 1];
    System.assertEquals(7, toAssert.NumberOfOpenCases__c);
    System.assertEquals(3, toAssert.NumberOfClosedCases__c);
  }

  @isTest
  private static void bulkTest() {
    // Given
    TestDataFactory factory = new TestDataFactory();
    List<Account> accounts = factory.createTestObjects(Account.getSObjectType(), 10, true);
    List<Case> cases = factory.createTestObjects(Case.getSObjectType(), 1000, false);
    for (Case newCase :cases) {
      Integer i = cases.indexOf(newCase) / 100;
      newCase.AccountId = accounts[i].Id;
      if (cases.indexOf(newCase) < i * 100 + 30) {
        newCase.Status = 'Closed';
      }
    }

    // When
    Test.startTest();
    insert cases;
    Test.stopTest();

    // Then
    Account toAssert = [SELECT Id, NumberOfClosedCases__c, NumberOfOpenCases__c
                       FROM Account
                       WHERE Id IN :accounts
                       LIMIT 1];
    System.assertEquals(70, toAssert.NumberOfOpenCases__c);
    System.assertEquals(30, toAssert.NumberOfClosedCases__c);
  }
}