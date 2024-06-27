import { useState, useEffect } from 'react'
import { supabase } from '../../lib/supabase'
import { StyleSheet, Alert, View } from 'react-native'
import { Button, Text } from '@rneui/themed'
import { Session } from '@supabase/supabase-js'

export default function HomeScreen({ session }: { session: Session }) {
    const [loading, setLoading] = useState(true)
    const [username, setUserId] = useState('')

    useEffect(() => {
        if (session) getProfile()
    }, [session])

    async function getProfile() {
        try {
            setLoading(true)
            if (!session?.user) throw new Error('No user on the session!')

            const { data, error, status } = await supabase
                .from('profiles')
                .select(`id`)
                .eq('id', session?.user.id)
                .single()
            if (error && status !== 406) {
                throw error
            }

            if (data) {
                setUserId(data.id)
            }
        } catch (error) {
            if (error instanceof Error) {
                Alert.alert(error.message)
            }
        } finally {
            setLoading(false)
        }
    }

    return (
        <View style={styles.container}>
            <View>
                <Text>You're logged in!</Text>
            </View>

            <Button
                onPress={async () => {
                    console.log('get token link from api')
                }}
            >
                <Text>Connect Accounts</Text>
            </Button>
        </View>
    )
}

const styles = StyleSheet.create({
    container: {
        marginTop: 40,
        padding: 12,
    },
    verticallySpaced: {
        paddingTop: 4,
        paddingBottom: 4,
        alignSelf: 'stretch',
    },
    mt20: {
        marginTop: 20,
    },
})
