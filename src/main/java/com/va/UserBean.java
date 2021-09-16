package com.va;

import java.sql.Date;
import java.sql.Timestamp;

public class UserBean {

	private String firstName;
	private String lastName;
	private String ssn;
	private String dateOfBirth;
	private String site;
	private int randomNumber;
	private String treatment;
	private String treatmentValue;
	private Timestamp randomizedDateTime;
	private String userId;

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getSsn() {
		return ssn;
	}

	public void setSsn(String ssn) {
		this.ssn = ssn;
	}

	public String getDateOfBirth() {
		return dateOfBirth;
	}

	public void setDateOfBirth(String dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}

	public String getSite() {
		return site;
	}

	public void setSite(String site) {
		this.site = site;
	}

	public int getRandomNumber() {
		return randomNumber;
	}

	public void setRandomNumber(int randomNumber) {
		this.randomNumber = randomNumber;
	}

	public String getTreatment() {
		return treatment;
	}

	public void setTreatment(String treatment) {
		this.treatment = treatment;
	}

	public String getTreatmentValue() {
		return treatmentValue;
	}

	public void setTreatmentValue(String treatmentValue) {
		this.treatmentValue = treatmentValue;
	}

	public Timestamp getRandomizedDateTime() {
		return randomizedDateTime;
	}

	public void setRandomizedDateTime(Timestamp randomizedDateTime) {
		this.randomizedDateTime = randomizedDateTime;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

}
