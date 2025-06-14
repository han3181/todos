<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ItemList extends Model
{
    protected $table = 'item_lists';
    protected $fillable = [
        'title',
        'description',
        'due_date',
        'category',
        'isCompleted',
        'isPriority',
    ];

    protected $casts = [
        'due_date' => 'date',
        'isCompleted' => 'boolean',
        'isPriority' => 'boolean',
    ];
}
