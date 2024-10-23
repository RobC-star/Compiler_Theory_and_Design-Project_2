/* CMSC 430 Compiler Theory and Design
   Project 1 Skeleton
   UMGC CITE, Summer 2023
   Robert Carswell
   6 February 2024

   This file contains the bodies of the functions that produce the compilation listing. The 
   lastLine function will calculate the total error and display a success message or an 
   error message with the error count by category. The appendError function will count the
   number of errors by category and creates an error queue. The displayError function will
   remove and print the error messages as they occur. No change during Project 2.*/

#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include <queue> // Added

static int lineNumber;
static queue<string> errorQueue; // Added
static int lexicalErrorCount = 0; // Added
static int syntaxErrorCount = 0; // Added
static int semanticErrorCount = 0; // Added
static string error = "";

static void displayErrors();

void firstLine(){

	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine(){

	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

// Function to display the summary of errors and compilation status
void lastLine(){
	printf("\r");
	displayErrors();
	printf("\n\n");
	int totalErrors(lexicalErrorCount+syntaxErrorCount+semanticErrorCount);

    if (totalErrors == 0) {
        printf("%s\n\n", "Compilation Successful");
    }
	else{
		printf("%s%d\n", "Lexical Errors: ", lexicalErrorCount);
		printf("%s%d\n", "Syntax Errors: ", syntaxErrorCount);
		printf("%s%d\n\n", "Semantic Errors: ", semanticErrorCount);   
    }
}

// Function to append errors to the queue and update error counts
void appendError(ErrorCategories errorCategory, string message){

	// Messages corresponding to each error category
    string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate ",
		"Semantic Error, Undeclared " 
	};

	// Switch statement to update error counts based on error category
	switch(errorCategory){
		case LEXICAL:lexicalErrorCount++; break;
		case SYNTAX:syntaxErrorCount++; break;
		case GENERAL_SEMANTIC:semanticErrorCount++; break;
	}

	// Push the error message to the queue
	errorQueue.push(messages[errorCategory] + message);
	// printf("%s\n", errorQueue.front().c_str());
}

void displayErrors(){

	// Function to display errors stored in the queue
	while (!errorQueue.empty()){
        printf("%s\n", errorQueue.front().c_str());
		errorQueue.pop();
    }
}
