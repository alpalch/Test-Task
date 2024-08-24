/**
 * @author            : ValeriyPalchenko
 * @ticket reference  : 
 * @Created on        : 22-06-2024
 * @last modified on  : 24-08-2024
 * @last modified by  : ValeriyPalchenko
**/
@isTest
public with sharing class TestDataFactory {

  private Integer valueCounter;

  Schema.DescribeFieldResult fieldDescribe;

  public TestDataFactory() {
    this.valueCounter = 0;
  }

  public List<SObject> createTestObjects(Schema.SObjectType objectType, 
                                         Integer objectNumber, 
                                         Boolean isInsert) {
    
    List<SObject> objects = new List<SObject>();
    Map<String, Schema.SObjectField> fields = objectType.getDescribe().fields.getMap();

    for (Integer i = 0; i < objectNumber; i++) {
      SObject obj = objectType.newSObject();

      for(Schema.SObjectField field :fields.values()) {
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
  
        Object fieldValue;
  
        if (!fieldDescribe.isNillable() && fieldDescribe.isUpdateable()) {
          this.fieldDescribe = fieldDescribe;
  
          fieldValue = generateFieldValue(fieldDescribe.getType(), fieldDescribe.isUnique());
          obj.put(field, fieldValue);
        }
      }
      objects.add(obj);
    }
    
    if (isInsert) {
      insert objects;
    }

    return objects;
  }

  private Object generateFieldValue(Schema.DisplayType fieldType, Boolean isUnique) {
    switch on fieldType {
      when String {
        return generateString();
      }
      when Integer {
        return generateInteger();
      }
      when Date {
        return Date.today();
      }
      when Datetime {
        return Datetime.now();
      }
      when Reference {
        return generateReference();
      }
      when Percent {
        return generateDecimal() / 100;
      }
      when Currency {
        return generateDecimal();
      }
      when Email {
        return generateEmail();
      }
      when Picklist {
        return getPicklistValue();
      }
      when Multipicklist {
        return getPicklistValue();
      }
      when Boolean {
        return false;
      }
      when else {
        return null;
      }
    }
  }

  private String generateString() {
    String toReturn = 'TestString' + this.valueCounter;
    this.valueCounter++;
    return toReturn;
  }

  private Integer generateInteger() {
    Integer toReturn = this.valueCounter;
    this.valueCounter++;
    return toReturn;
  }

  private Decimal generateDecimal() {
    Decimal toReturn = Decimal.valueOf(this.valueCounter);
    this.valueCounter++;
    return toReturn;
  }

  private String generateEmail() {
    String toReturn = 'test' + this.valueCounter + '@test.com';
    this.valueCounter++;
    return toReturn;
  }

  private Object generateReference() {
    if (isOwnerField(this.fieldDescribe) && this.fieldDescribe.isUpdateable()) {
  
      if (this.fieldDescribe.getName() == 'RelatedId') {
        return null;
      }

      return UserInfo.getUserId();

    }
    return createTestObjects(this.fieldDescribe.getReferenceTo().get(0), 1, true).get(0).Id;
  }

  private Object getPicklistValue() {
    return this.fieldDescribe.getPicklistValues().get(0);
  }

  private Boolean isOwnerField(Schema.DescribeFieldResult fieldDescribe) {
    return (fieldDescribe.getReferenceTo()?.get(0) == Schema.User.getSObjectType() ||
            fieldDescribe.getReferenceTo()?.get(0) == Schema.Group.getSObjectType());
  }
}