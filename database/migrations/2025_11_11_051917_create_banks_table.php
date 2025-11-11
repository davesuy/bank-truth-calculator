<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('banks', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('logo')->nullable();
            $table->decimal('apy', 5, 2); // Annual Percentage Yield
            $table->decimal('minimum_deposit', 12, 2)->default(0);
            $table->enum('type', ['sponsored', 'low_rate']); // sponsored = left side, low_rate = right side
            $table->integer('rank')->default(0); // for sorting
            $table->boolean('is_active')->default(true);
            $table->text('description')->nullable();
            $table->string('website_url')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('banks');
    }
};

