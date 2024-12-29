#include <mpi.h>
#include <iostream>
#include <vector>
#include <chrono>

int main(int argc, char* argv[]) {
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    const size_t N = 2000000000;  // Total vector size
    const size_t local_N = N / size;  // Size for each process
    
    std::vector<double> local_numbers(local_N);

    // Initialize local portion of the vector
    for(size_t i = 0; i < local_N; i++) {
        local_numbers[i] = rank * local_N + i;
    }

    // Start timing
    auto start = MPI_Wtime();

    // Calculate local sum
    double local_sum = 0.0;
    for(size_t i = 0; i < local_N; i++) {
        local_sum += local_numbers[i];
    }

    // Reduce all local sums to get total sum
    double total_sum = 0.0;
    MPI_Reduce(&local_sum, &total_sum, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    // End timing
    auto end = MPI_Wtime();

    if (rank == 0) {
        std::cout << "Total sum: " << total_sum << std::endl;
        std::cout << "Time taken: " << (end - start) * 1000 << " milliseconds" << std::endl;
        std::cout << "Number of processes: " << size << std::endl;
        
        char processor_name[MPI_MAX_PROCESSOR_NAME];
        int name_len;
        MPI_Get_processor_name(processor_name, &name_len);
        std::cout << "Master process running on: " << processor_name << std::endl;
    }

    // Print which node each process is running on
    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len);
    printf("Process %d running on: %s\n", rank, processor_name);

    MPI_Finalize();
    return 0;
}
