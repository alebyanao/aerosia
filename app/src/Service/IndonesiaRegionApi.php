<?php

class IndonesiaRegionAPI
{
    const API_BASE_URL = 'https://www.emsifa.com/api-wilayah-indonesia/api';
    
    /**
     * Get all provinces
     * @return array
     */
    public static function getProvinces()
    {
        $url = self::API_BASE_URL . '/provinces.json';
        $response = file_get_contents($url);
        $data = json_decode($response, true);
        
        $provinces = [];
        foreach ($data as $province) {
            $provinces[$province['id']] = $province['name'];
        }
        
        return $provinces;
    }
    
    /**
     * Get cities/regencies by province ID
     * @param string $provinceId
     * @return array
     */
    public static function getCitiesByProvince($provinceId)
    {
        if (empty($provinceId)) {
            return [];
        }
        
        $url = self::API_BASE_URL . "/regencies/{$provinceId}.json";
        $response = @file_get_contents($url);
        
        if ($response === false) {
            return [];
        }
        
        $data = json_decode($response, true);
        
        $cities = [];
        foreach ($data as $city) {
            $cities[$city['id']] = $city['name'];
        }
        
        return $cities;
    }
    
    /**
     * Get province name by ID
     * @param string $provinceId
     * @return string|null
     */
    public static function getProvinceName($provinceId)
    {
        $provinces = self::getProvinces();
        return isset($provinces[$provinceId]) ? $provinces[$provinceId] : null;
    }
    
    /**
     * Get city name by ID
     * @param string $provinceId
     * @param string $cityId
     * @return string|null
     */
    public static function getCityName($provinceId, $cityId)
    {
        $cities = self::getCitiesByProvince($provinceId);
        return isset($cities[$cityId]) ? $cities[$cityId] : null;
    }
}