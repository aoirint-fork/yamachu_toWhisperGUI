using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using ToWhisperNet;
using JsAPI = System.Func<object, System.Threading.Tasks.Task<object>>;

namespace ToWhisper
{
    public class Program
    {
        static void Main() {}

        public async Task<object> Invoke(object obj)
        {
            Whisper whisper = new Whisper();

            return new
            {
                generateWhisper = (JsAPI)(async (_params) => {
                    var paramsPair = (IDictionary<string, object>)_params;
                    var inputFile = paramsPair["input_file"] as string;
                    var outputFile = paramsPair["output_file"] as string;

                    var wave = new Wave();
                    try {
                        wave.Read(inputFile);
                        whisper.Convert(wave);
                        wave.Write(outputFile, wave.Data);
                        if (paramsPair.ContainsKey("vowel_output_file")) {
                            var vowelFile = paramsPair["vowel_output_file"] as string;
                            wave.Write(vowelFile, wave.EData);
                        }
                    } catch(Exception e) {
                        return new {
                            error = e.Message
                        };
                    }
                    
                    return null;
                }),
                setParameters = (JsAPI)(async (_params) => {
                    var paramsPair = (IDictionary<string, object>)_params;
                    
                    if (paramsPair.ContainsKey("order")) {
                        whisper.Order = Convert.ToInt32(paramsPair["order"] as string);
                    }
                    if (paramsPair.ContainsKey("rate")) {
                        whisper.Rate = Convert.ToDouble(paramsPair["rate"] as string);
                    }
                    if (paramsPair.ContainsKey("hpf")) {
                        whisper.Hpf = Convert.ToDouble(paramsPair["hpf"] as string);
                    }
                    if (paramsPair.ContainsKey("lpf")) {
                        whisper.Lpf = Convert.ToDouble(paramsPair["lpf"] as string);
                    }
                    if (paramsPair.ContainsKey("framet")) {
                        whisper.FrameT = Convert.ToDouble(paramsPair["framet"] as string);
                    }

                    return null;
                }),
                resetParameters = (JsAPI)(async (_) => {
                    whisper.Order = 0;
                    whisper.Rate = 0.0;
                    whisper.Hpf = 0.97;
                    whisper.Lpf = 0.97;
                    whisper.FrameT = 20.0;

                    return null;
                }),
            };
        }
    }
}
