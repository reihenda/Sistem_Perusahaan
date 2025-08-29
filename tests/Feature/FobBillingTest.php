<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Billing;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;

class FobBillingTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    /** @test */
    public function fob_customers_appear_in_billing_select_list()
    {
        // Buat admin user untuk akses
        $admin = User::factory()->create([
            'role' => 'admin'
        ]);

        // Buat customer reguler
        $customer = User::factory()->create([
            'role' => 'customer',
            'name' => 'Regular Customer',
            'email' => 'customer@test.com'
        ]);

        // Buat customer FOB
        $fobCustomer = User::factory()->create([
            'role' => 'fob',
            'name' => 'FOB Customer', 
            'email' => 'fob@test.com'
        ]);

        // Login sebagai admin
        $this->actingAs($admin);

        // Akses halaman select customer untuk billing
        $response = $this->get('/billings/select-customer');

        // Pastikan response sukses
        $response->assertStatus(200);

        // Pastikan kedua jenis customer muncul di halaman
        $response->assertSee('Regular Customer');
        $response->assertSee('FOB Customer');
        
        // Pastikan label jenis customer muncul
        $response->assertSee('Customer'); // Badge untuk customer reguler
        $response->assertSee('FOB'); // Badge untuk customer FOB
    }

    /** @test */
    public function fob_customer_can_create_billing()
    {
        // Buat admin user
        $admin = User::factory()->create([
            'role' => 'admin'
        ]);

        // Buat customer FOB dengan data pricing
        $fobCustomer = User::factory()->create([
            'role' => 'fob',
            'name' => 'Test FOB Customer',
            'email' => 'testfob@test.com',
            'harga_per_meter_kubik' => 5000,
            'koreksi_meter' => 1.0 // FOB selalu menggunakan koreksi meter 1.0
        ]);

        // Login sebagai admin
        $this->actingAs($admin);

        // Data billing untuk customer FOB
        $billingData = [
            'billing_number' => '001/MPS/BIL-TEST/01/2024',
            'billing_date' => '2024-01-15',
            'period_type' => 'monthly',
            'month' => 1,
            'year' => 2024
        ];

        // Post data billing untuk customer FOB
        $response = $this->post("/billings/{$fobCustomer->id}/store", $billingData);

        // Pastikan redirect ke show page (billing berhasil dibuat)
        $response->assertRedirect();

        // Pastikan billing tersimpan di database
        $this->assertDatabaseHas('billings', [
            'customer_id' => $fobCustomer->id,
            'billing_number' => '001/MPS/BIL-TEST/01/2024',
            'period_month' => 1,
            'period_year' => 2024
        ]);
    }

    /** @test */
    public function regular_customers_appear_first_in_billing_list()
    {
        // Buat admin user
        $admin = User::factory()->create([
            'role' => 'admin'
        ]);

        // Buat customer dengan nama yang akan menguji urutan
        $zCustomer = User::factory()->create([
            'role' => 'customer',
            'name' => 'Z Regular Customer', // Nama diakhir alphabet
            'email' => 'zcustomer@test.com'
        ]);

        $aFobCustomer = User::factory()->create([
            'role' => 'fob',
            'name' => 'A FOB Customer', // Nama diawal alphabet
            'email' => 'afob@test.com'
        ]);

        // Login sebagai admin
        $this->actingAs($admin);

        // Akses halaman select customer
        $response = $this->get('/billings/select-customer');

        $content = $response->getContent();
        
        // Pastikan customer reguler muncul sebelum FOB
        // meskipun nama FOB lebih awal secara alphabet
        $customerPosition = strpos($content, 'Z Regular Customer');
        $fobPosition = strpos($content, 'A FOB Customer');
        
        $this->assertTrue($customerPosition < $fobPosition, 
            'Customer reguler harus muncul sebelum customer FOB');
    }
}
