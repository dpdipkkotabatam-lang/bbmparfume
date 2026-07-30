-- Jalankan seluruh SQL ini satu kali di Supabase > SQL Editor.
-- SQL ini menambahkan kolom yang dipakai form pesanan panel karyawan.

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS kode_pesanan TEXT,
  ADD COLUMN IF NOT EXISTS nama_pelanggan TEXT,
  ADD COLUMN IF NOT EXISTS no_whatsapp TEXT,
  ADD COLUMN IF NOT EXISTS alamat TEXT,
  ADD COLUMN IF NOT EXISTS product_id BIGINT,
  ADD COLUMN IF NOT EXISTS nama_produk TEXT,
  ADD COLUMN IF NOT EXISTS jumlah INTEGER DEFAULT 1,
  ADD COLUMN IF NOT EXISTS harga_satuan NUMERIC DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total NUMERIC DEFAULT 0,
  ADD COLUMN IF NOT EXISTS metode_pembayaran TEXT DEFAULT 'tunai',
  ADD COLUMN IF NOT EXISTS catatan TEXT,
  ADD COLUMN IF NOT EXISTS status_pembayaran TEXT DEFAULT 'belum_bayar',
  ADD COLUMN IF NOT EXISTS status_pesanan TEXT DEFAULT 'baru',
  ADD COLUMN IF NOT EXISTS created_by BIGINT,
  ADD COLUMN IF NOT EXISTS processed_by BIGINT,
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

CREATE UNIQUE INDEX IF NOT EXISTS orders_kode_pesanan_key
ON public.orders (kode_pesanan)
WHERE kode_pesanan IS NOT NULL;

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Karyawan aktif membuat pesanan" ON public.orders;
CREATE POLICY "Karyawan aktif membuat pesanan"
ON public.orders
FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.karyawan
    WHERE karyawan.auth_user_id = auth.uid()
      AND karyawan.status = 'aktif'
  )
);

NOTIFY pgrst, 'reload schema';
