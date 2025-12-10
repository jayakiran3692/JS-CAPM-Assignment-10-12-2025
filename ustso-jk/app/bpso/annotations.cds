using MasterDataService as service from '../../srv/service';
annotate service.BusinessPartners with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'bpAddress_street',
                Value : bpAddress_street,
            },
            {
                $Type : 'UI.DataField',
                Label : 'bpAddress_city',
                Value : bpAddress_city,
            },
            {
                $Type : 'UI.DataField',
                Label : 'bpAddress_region',
                Value : bpAddress_region,
            },
            {
                $Type : 'UI.DataField',
                Label : 'bpAddress_country',
                Value : bpAddress_country,
            },
            {
                $Type : 'UI.DataField',
                Label : 'bpAddress_postal',
                Value : bpAddress_postal,
            },
            {
                $Type : 'UI.DataField',
                Value : bpCode,
            },
            {
                $Type : 'UI.DataField',
                Value : bpName,
            },
            {
                $Type : 'UI.DataField',
                Value : bpType,
            },
            {
                $Type : 'UI.DataField',
                Value : email,
            },
            {
                $Type : 'UI.DataField',
                Label : 'phone',
                Value : phone,
            },
            {
                $Type : 'UI.DataField',
                Value : gstNumber,
            },
            {
                $Type : 'UI.DataField',
                Value : paymentTerms_code,
            },
            {
                $Type : 'UI.DataField',
                Value : paymentTerms_text,
            },
            {
                $Type : 'UI.DataField',
                Value : isActive,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'bpAddress_street',
            Value : bpAddress_street,
        },
        {
            $Type : 'UI.DataField',
            Label : 'bpAddress_city',
            Value : bpAddress_city,
        },
        {
            $Type : 'UI.DataField',
            Label : 'bpAddress_region',
            Value : bpAddress_region,
        },
        {
            $Type : 'UI.DataField',
            Label : 'bpAddress_country',
            Value : bpAddress_country,
        },
        {
            $Type : 'UI.DataField',
            Label : 'bpAddress_postal',
            Value : bpAddress_postal,
        },
    ],
);

