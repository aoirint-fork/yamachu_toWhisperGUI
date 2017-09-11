using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Threading.Tasks;
using DotnetWorld.API;

namespace ToWhisperNet
{
    /// <summary>
    /// Waveファイル操作
    /// </summary>
    public class Wave
    {
        /// <summary>
        /// 波形データ
        /// </summary>
        public double[] Data { get; set; }
        public double[] EData { get; set; }
        internal WaveFormat Format { get; private set; }
        /// <summary>
        /// 音声データを読み込みます
        /// </summary>
        /// <param name="filename">ファイル名</param>
        /// <returns>読み込んだデータをdouble[](-1.0～1.0)に変換したもの</returns>
        public double[] Read(string filename)
        {
            Data = null;

            var wavLength = Tools.GetAudioLength(filename);
            if (wavLength == 0) {
                throw new FileNotFoundException($"Cannot Access File {filename}");
            }
            if (wavLength == -1) {
                throw new FormatException("Not supported file format, support only Monaural wav");
            }

            var x = new double[wavLength];
            int fs, nbit;
            Tools.WavRead(filename, out fs, out nbit, x);

            if (nbit != 16) {
                throw new FormatException("Support only 16bit wav");
            }

            Data = CodeNonZeroCompensation(x);
            Format = new WaveFormat{
                BitDepth = nbit,
                SampleRate = fs,
            };

            return Data;
        }
        /// <summary>
        /// 音声データをファイルに出力します
        /// </summary>
        /// <param name="filename">出力ファイル名</param>
        /// <param name="data">音声データ</param>
        public void Write(string filename, double[] data)
            => Tools.WavWrite(DecodeNonZeroCompensation(data), data.Length, Format.SampleRate, Format.BitDepth, filename);

        private const double DIVED = 1 / 32767.0;

        private double[] CodeNonZeroCompensation(double[] input)
            => input.Select(x => x != 0.0 ? x : DIVED).ToArray();

        private double[] DecodeNonZeroCompensation(double[] input)
            => input.Select(x => x != DIVED ? x : 0).ToArray();
    }

    internal class WaveFormat
    {
        public int SampleRate { get; set; }
        public int BitDepth { get; set; } // only 16bit
    }
}
