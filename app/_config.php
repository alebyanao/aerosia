<?php

use SilverStripe\Security\Member;
use SilverStripe\SiteConfig\SiteConfig;

Member::add_extension(MemberExtension::class);
SiteConfig::add_extension( CustomSiteConfig::class);