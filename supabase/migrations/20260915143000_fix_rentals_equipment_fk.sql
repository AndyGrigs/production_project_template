/*
  # Fix rentals.equipment_id foreign key

  Проблема: ON DELETE SET NULL + NOT NULL на одній колонці.
  При DELETE FROM equipment Postgres кидає 23502 (not_null_violation).

  Рішення:
  1. FK стає RESTRICT — історія оренд захищена на рівні БД.
  2. equipment отримує is_archived для м'якого видалення.
  3. rentals зберігає назву обладнання на момент оренди (денормалізація для історії).
*/

-- 1. Прибираємо суперечливий constraint
ALTER TABLE rentals
  DROP CONSTRAINT IF EXISTS rentals_equipment_id_fkey;

-- 2. Створюємо коректний
ALTER TABLE rentals
  ADD CONSTRAINT rentals_equipment_id_fkey
  FOREIGN KEY (equipment_id)
  REFERENCES equipment(id)
  ON DELETE RESTRICT;

-- 3. Знімок назви обладнання на момент оренди
ALTER TABLE rentals
  ADD COLUMN IF NOT EXISTS equipment_name text;

-- 4. М'яке видалення обладнання
ALTER TABLE equipment
  ADD COLUMN IF NOT EXISTS is_archived boolean NOT NULL DEFAULT false;

CREATE INDEX IF NOT EXISTS idx_equipment_is_archived
  ON equipment(is_archived);
