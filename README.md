# Veryfi Framework for Swift 5.5

[![Swift - version](https://img.shields.io/badge/Swift-5.5-F16D39.svg?style=flat)](https://cocoapods.org)
[![pod](https://img.shields.io/cocoapods/v/NSString+ShellSplit.svg?style=flat)](https://cocoapods.org)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

![Veryfi Logo](https://cdn.veryfi.com/logos/veryfi-logo-wide-github.png)

## Table of Contents

- [Installation](#installation)
- [Getting Started](#getting-started)
  - [Obtaining Client ID and user keys](#obtaining-client-id-and-user-keys)
  - [Swift Framework Client Library](#swift-framework-client-library)
  - [Extracting Data](#extracting-data)
  - [Response](#response)
  - [Updating a document](#updating-a-document)
- [Need help?](#need-help)

**veryfi-swift** is a Swift 5.5 framework for communicating with the [Veryfi OCR API](https://veryfi.com/api/)

## Installation

Install from [cocoapods](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm), a package manager for Swift. **(Replace with pods)**

```bash
pod install veryfi_swift
```

You may need to run the above command with `sudo`.

## Getting Started

### Obtaining Client ID and user keys

If you don't have an account with Veryfi, please go ahead and register here: [https://hub.veryfi.com/signup/api/](https://hub.veryfi.com/signup/api/)

### Swift Framework Client Library

The **Veryfi** library can be used to communicate with Veryfi API. All available functionality is described here <https://veryfi.github.io/veryfi-nodejs/Client.html> **(Replace with Swift GH site)**

Below is the sample script using **veryfi** to read and extract data from a document:

### Extracting Data

```swift
import veryfi_swift
let clientId: String = 'your_client_id'
let clientSecret: String = 'your_client_secret'
let username: String = 'your_username'
let apiKey: String = 'your_api_key'

let categories: [String] = ['Grocery', 'Utilities', 'Travel']
let fileData: Data = Data(YOUR FILE AS A DATA OBJECT)
```

This submits a document for processing (3-5 seconds for a response)

```swift
let myClient: Client  = Client(clientId: "", clientSecret: "", username: "", apiKey: "")
let response = await myClient.processDocument(fileName: "My_Receipt.png", fileData: fileData, categories: categories)
print(response)
```

...or with a URL

```swift
let response = await myClient.processDocumentUrl(fileUrl: url);
print(response)
```

### Response

```swift
>>> {
      abn_number: '',
      account_number: '',
      bill_to_address: '2 Court Square\nNew York, NY 12210',
      bill_to_name: 'John Smith',
      bill_to_vat_number: '',
      card_number: '',
      cashback: 0,
      category: 'Repairs & Maintenance',
      created: '2021-06-28 19:20:02',
      currency_code: 'USD',
      date: '2019-02-11 00:00:00',
      delivery_date: '',
      discount: 0,
      document_reference_number: '',
      document_title: '',
      document_type: 'invoice',
      due_date: '2019-02-26',
      duplicate_of: 37055375,
      external_id: '',
      id: 37187909,
      img_file_name: 'receipt.png',
      img_thumbnail_url: 'https://scdn.veryfi.com/receipts/thumbnail.png',
      img_url: 'https://scdn.veryfi.com/receipts/receipt.png',
      insurance: '',
      invoice_number: 'US-001',
      is_duplicate: 1,
      line_items: [
        {
          date: '',
          description: 'Front and rear brake cables',
          discount: 0,
          id: 68004313,
          order: 0,
          price: 100,
          quantity: 1,
          reference: '',
          section: '',
          sku: '',
          tax: 0,
          tax_rate: 0,
          total: 100,
          type: 'product',
          unit_of_measure: ''
        },
        {
          date: '',
          description: 'New set of pedal arms',
          discount: 0,
          id: 68004315,
          order: 1,
          price: 15,
          quantity: 2,
          reference: '',
          section: '',
          sku: '',
          tax: 0,
          tax_rate: 0,
          total: 30,
          type: 'product',
          unit_of_measure: ''
        },
        {
          date: '',
          description: 'Labor 3hrs',
          discount: 0,
          id: 68004316,
          order: 2,
          price: 5,
          quantity: 3,
          reference: '',
          section: '',
          sku: '',
          tax: 0,
          tax_rate: 0,
          total: 15,
          type: 'service',
          unit_of_measure: ''
        }
      ],
      notes: '',
      ocr_text: '\n' +
        '\fEast Repair Inc.\n' +
        '1912 Harvest Lane\n' +
        'New York, NY 12210\n' +
        '\n' +
        'BILL TO\t\tSHIP TO\tRECEIPT #\tUS-001\n' +
        'John Smith\t\tJohn Smith\tRECEIPT DATE\t11/02/2019\n' +
        '2 Court Square\t3787 Pineview Drive\n' +
        '\tP.O.#\t2312/2019\n' +
        'New York, NY 12210\tCambridge, MA 12210\n' +
        '\tDUE DATE\t26/02/2019\n' +
        'Receipt Total\t\t\t$154.06\n' +
        '\n' +
        'QTY DESCRIPTION\t\t\tUNIT PRICE\tAMOUNT\n' +
        '1\tFront and rear brake cables\t\t100.00\t100.00\n' +
        '2\tNew set of pedal arms\t\t\t15.00\t30.00\n' +
        '3\tLabor 3hrs\t\t\t\t5.00\t15.00\n' +
        '\n' +
        '\tSubtotal\t145.00\n' +
        '\tSales Tax 6.25%\t9.06\n' +
        '\n' +
        'TERMS & CONDITIONS\n' +
        'Payment is due within 15 days\n' +
        'Please make checks payable to: East Repair\n' +
        '\tJohn Smith\n' +
        '\tInc.\n',
      order_date: '',
      payment_display_name: '',
      payment_terms: '15 days',
      payment_type: '',
      phone_number: '',
      purchase_order_number: '2312/2019',
      rounding: 0,
      service_end_date: '',
      service_start_date: '',
      ship_date: '',
      ship_to_address: '3787 Pineview Drive\nCambridge, MA 12210',
      ship_to_name: 'John Smith',
      shipping: 0,
      store_number: '',
      subtotal: 145,
      tax: 9.06,
      tax_lines: [ { base: 0, name: 'Sales', order: 0, rate: 6.25, total: 9.06 } ],
      tip: 0,
      total: 154.06,
      total_weight: '',
      tracking_number: '',
      updated: '2021-06-28 19:20:03',
      vat_number: '',
      vendor: {
        address: '1912 Harvest Lane\nNew York, NY 12210',
        category: 'Car Repair',
        email: '',
        fax_number: '',
        name: 'East Repair',
        phone_number: '',
        raw_name: 'East Repair Inc.',
        vendor_logo: 'https://cdn.veryfi.com/logos/tmp/560806841.png',
        vendor_reg_number: '',
        vendor_type: 'Car Repair',
        web: ''
      },
      vendor_account_number: '',
      vendor_bank_name: '',
      vendor_bank_number: '',
      vendor_bank_swift: '',
      vendor_iban: ''
    }
```

### Updating a document

```swift
let newVendor = ["name": "Starbucks", "address": "123 Easy Str, San Francisco, CA 94158"]
let newCategory = "Meals & Entertainment"
let newTotal = 11.23
myClient.updateDocument(documentId: 12345, params:
    [
        'vendor': newVendor,
        'category': newCategory,
        'total': newTotal
    ])
```

## Need help?

If you run into any issue or need help installing or using the library, please contact support@veryfi.com.

If you found a bug in this library or would like new features added, then open an issue or pull requests against this repo!

To learn more about Veryfi visit <https://www.veryfi.com/>
