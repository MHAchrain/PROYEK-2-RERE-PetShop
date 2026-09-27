import { useEffect, useState } from 'react';
import {
    getGroomingServices,
    getGroomingSlots,
    createGroomingBooking,
} from '../services/groomingservice';

const initialBookingData = {
    serviceId: '',
    petName: '',
    petType: '',
    petBreed: '',
    petSize: '',
    petNote: '',
    time: '',
};

export default function useGroomingBooking() {
    const [services, setServices] = useState([]);
    const [slots, setSlots] = useState([]);
    const [selectedDate, setSelectedDateState] = useState('');
    const [bookingData, setBookingData] = useState(initialBookingData);
    const [loading, setLoading] = useState(false);
    const [slotsLoading, setSlotsLoading] = useState(false);
    const [error, setError] = useState('');

    useEffect(() => {
        let isCurrent = true;

        getGroomingServices()
        .then((result) => {
            if (isCurrent) setServices(result);
        })
        .catch(() => {
            if (isCurrent) setError('Layanan grooming gagal dimuat.');
        });

        return () => {
        isCurrent = false;
        };
    }, []);

    useEffect(() => {
        let isCurrent = true;

        if (!selectedDate) {
        setSlots([]);
        setSlotsLoading(false);
        return () => {
            isCurrent = false;
        };
        }

        setSlotsLoading(true);
        setError('');

        getGroomingSlots(selectedDate)
        .then((result) => {
            if (isCurrent) setSlots(result);
        })
        .catch(() => {
            if (isCurrent) {
            setSlots([]);
            setError('Slot grooming gagal dimuat.');
            }
        })
        .finally(() => {
            if (isCurrent) setSlotsLoading(false);
        });

        return () => {
        isCurrent = false;
        };
    }, [selectedDate]);

    const setSelectedDate = (date) => {
        setSelectedDateState(date);
        setBookingData((current) => ({ ...current, time: '' }));
        setError('');
    };

    const updateBookingField = (field, value) => {
        setBookingData((current) => ({
        ...current,
        [field]: value,
        }));
        setError('');
    };

    const submitBooking = async () => {
        const requiredFields = [
        ['serviceId', 'Pilih layanan grooming terlebih dahulu.'],
        ['petName', 'Isi nama hewan terlebih dahulu.'],
        ['petType', 'Isi jenis hewan terlebih dahulu.'],
        ['time', 'Pilih slot grooming terlebih dahulu.'],
        ];

        const missingField = requiredFields.find(
        ([field]) => !String(bookingData[field] ?? '').trim(),
        );

        if (missingField) {
        setError(missingField[1]);
        return null;
        }

        if (!selectedDate) {
        setError('Pilih tanggal grooming terlebih dahulu.');
        return null;
        }

        setLoading(true);
        setError('');

        try {
        return await createGroomingBooking({
            ...bookingData,
            date: selectedDate,
        });
        } catch (bookingError) {
        setError(bookingError.message || 'Booking gagal dibuat.');
        return null;
        } finally {
        setLoading(false);
        }
    };

    return {
        services,
        slots,
        selectedDate,
        setSelectedDate,
        bookingData,
        updateBookingField,
        loading,
        slotsLoading,
        error,
        submitBooking,
    };
}
