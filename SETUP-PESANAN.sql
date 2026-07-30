-- Jalankan seluruh SQL ini satu kali di Supabase > SQL Editor.
-- SQL ini menambahkan kolom yang dipakai form pesanan panel karyawan.

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS no_whatsapp TEXT,
  ADD COLUMN IF NOT EXISTS alamat TEXT,
  ADD COLUMN IF NOT EXISTS product_id BIGINT,
  ADD COLUMN IF NOT EXISTS nama_produk TEXT,
  ADD COLUMN IF NOT EXISTS jumlah INTEGER DEFAULT 1,
  ADD COLUMN IF NOT EXISTS harga_satuan NUMERIC DEFAULT 0,
  ADD COLUMN IF NOT EXISTS metode_pembayaran TEXT DEFAULT 'tunai',
  ADD COLUMN IF NOT EXISTS catatan TEXT;

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
