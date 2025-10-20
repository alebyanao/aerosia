<?php

use SilverStripe\ORM\DataExtension;

class MemberExtension extends DataExtension
{
    private static $table_name = "member_extension";
    private static $db = [
        'VerificationToken' => 'Varchar(255)',
        'IsVerified' => 'Boolean',
        'ResetPasswordToken' => 'Varchar(255)',
        'ResetPasswordExpiry' => 'Datetime',
        'GoogleID' => 'Varchar(255)',
    ];

    private static $indexes = [
        'GoogleID' => true,
        'VerificationToken' => true,
        'ResetPasswordToken' => true,
    ];

    public function updateSummaryFields(&$fields)
    {
        $fields['GoogleID'] = 'GoogleID';
        $fields['IsVerified'] = 'Terverifikasi';
    }

}