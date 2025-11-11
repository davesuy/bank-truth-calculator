<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bank extends Model
{
    protected $fillable = [
        'name',
        'logo',
        'apy',
        'minimum_deposit',
        'type',
        'rank',
        'is_active',
        'description',
        'website_url',
    ];

    protected $casts = [
        'apy' => 'decimal:2',
        'minimum_deposit' => 'decimal:2',
        'is_active' => 'boolean',
    ];

    // Scopes
    public function scopeSponsored($query)
    {
        return $query->where('type', 'sponsored')->where('is_active', true)->orderBy('rank');
    }

    public function scopeLowRate($query)
    {
        return $query->where('type', 'low_rate')->where('is_active', true)->orderBy('rank');
    }
}
