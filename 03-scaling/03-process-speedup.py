#!/usr/bin/env python3
import glob
import pandas as pd
import matplotlib.pyplot as plt

# Read all output files
data = []
for filename in glob.glob('speedup_*_*.out'):
    with open(filename, 'r') as f:
        line = f.readline().strip()
        threads, time, sum_result = map(float, line.split(','))
        data.append({'threads': int(threads), 'time': time})

# Create DataFrame and calculate speedup
df = pd.DataFrame(data)
df = df.sort_values('threads')
serial_time = df[df['threads'] == 1]['time'].iloc[0]
df['speedup'] = serial_time / df['time']
df['efficiency'] = df['speedup'] / df['threads']

# Print results
print("\nSpeedup Analysis Results:")
print("------------------------")
print(df.to_string(index=False))

# Create speedup plot
plt.figure(figsize=(10, 6))
plt.plot(df['threads'], df['speedup'], 'bo-', label='Actual Speedup')
plt.plot(df['threads'], df['threads'], 'r--', label='Linear Speedup')
plt.xlabel('Number of Threads')
plt.ylabel('Speedup')
plt.title('OpenMP Vector Addition Speedup Analysis')
plt.legend()
plt.grid(True)
plt.savefig('speedup_plot.png')
plt.close()

# Print summary
print("\nSummary:")
print(f"Best speedup: {df['speedup'].max():.2f}x with {df.loc[df['speedup'].idxmax(), 'threads']} threads")
print(f"Best efficiency: {df['efficiency'].max():.2f} with {df.loc[df['efficiency'].idxmax(), 'threads']} threads")
