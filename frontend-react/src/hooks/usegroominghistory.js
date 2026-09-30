import { useCallback, useEffect, useMemo, useState } from 'react';
import { useAuth } from '../context/authcontext';
import { getGroomingBookings } from '../services/groomingservice';

const tabs = [
    { id: 'semua', label: 'Semua' },
    { id: 'menunggu_pembayaran', label: 'Menunggu Pembayaran' },
    { id: 'terjadwal', label: 'Terjadwal' },
    { id: 'selesai', label: 'Selesai' },
    { id: 'dibatalkan', label: 'Dibatalkan' },
];

const getCurrentUserId = (user) =>
    user?.id ??
    user?.id_user ??
    user?.id_pelanggan ??
    user?.user?.id ??
    user?.pelanggan?.id_pelanggan ??
    user?.data?.user?.id ??
    user?.data?.pelanggan?.id_pelanggan ??
    null;

export default function useGroomingHistory() {
    const { user } = useAuth();
    const userId = getCurrentUserId(user);
    const [bookings, setBookings] = useState([]);
    const [activeTab, setActiveTab] = useState('semua');
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState('');
    const [refreshIndex, setRefreshIndex] = useState(0);

    useEffect(() => {
        let isCurrent = true;

        if (userId === null || userId === undefined || userId === '') {
        setBookings([]);
        setIsLoading(false);
        setError('');
        return () => {
            isCurrent = false;
        };
        }

        setIsLoading(true);
        setError('');

        getGroomingBookings(userId)
        .then((result) => {
            if (isCurrent) setBookings(Array.isArray(result) ? result : []);
        })
        .catch(() => {
            if (isCurrent) {
            setBookings([]);
            setError('Riwayat booking grooming gagal dimuat.');
            }
        })
        .finally(() => {
            if (isCurrent) setIsLoading(false);
        });

        return () => {
        isCurrent = false;
        };
    }, [userId, refreshIndex]);

    const filteredBookings = useMemo(
        () =>
        bookings.filter((booking) => {
            if (activeTab === 'semua') return true;
            if (activeTab === 'dibatalkan') {
            return ['dibatalkan', 'batal'].includes(booking.status);
            }

            return booking.status === activeTab;
        }),
        [activeTab, bookings],
    );

    const refreshHistory = useCallback(() => {
        setRefreshIndex((current) => current + 1);
    }, []);

    return {
        bookings,
        filteredBookings,
        activeTab,
        setActiveTab,
        tabs,
        isLoading,
        error,
        refreshHistory,
    };
}
