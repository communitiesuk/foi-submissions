# frozen_string_literal: true

FactoryBot.define do
  factory :published_request do
    payload do
      { generated: '2018-06-05 00:00',
        ref: 'FOI-1',
        type: 'FOI',
        datecreated: '2018-01-01',
        dateclosed: '2018-04-22',
        datepublished: '2018-04-23',
        url: 'http://foi.infreemation.co.uk/redirect/hackney?id=1',
        status: 'Closed',
        outcome: 'Rejected - Exempt',
        category: 'Local Businesses',
        keywords: 'Business, business rates',
        timespent: { unit: 'minutes', value: '0' },
        costtorespond: { unit: 'gbp', value: '0' },
        subject: 'Business Rates',
        requestbody: 'Initial FOI Request',
        exemptions: {
          exemption: 'S(21) - Information accessible by other means'
        },
        history: {
          response: [
            { responsebody: 'Thank you for your help',
              from: 'Customer',
              datetime: '2018-01-04 13:06' },
            { responsebody: "Dear Redacted\nFOI Response",
              from: 'Authority',
              datetime: '2018-01-03 12:05' },
            { responsebody: "Dear Redacted\nAutomated acknowledgement.",
              from: 'Authority',
              datetime: '2018-01-02 11:04' }
          ]
        } }
    end
  end
end
