import AsyncStorage from '@react-native-async-storage/async-storage'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://tqonkxhrucymdyndpjzf.supabase.co'
const supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxb25reGhydWN5bWR5bmRwanpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTYxNzk4MTAsImV4cCI6MjAzMTc1NTgxMH0.rGtsQPBxLHHatZaBs1JPxsp-E8chFQL11lFHfryKAxc'

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    auth: {
        storage: AsyncStorage,
        autoRefreshToken: true,
        persistSession: true,
        detectSessionInUrl: false,
    },
})
